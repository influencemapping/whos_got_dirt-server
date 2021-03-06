require 'digest/md5'
require 'json'

require 'active_support/cache'
require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/multi_route'
require 'whos_got_dirt'

module WhosGotDirt
  class Server < Sinatra::Base
    register Sinatra::CrossOrigin
    register Sinatra::MultiRoute
    enable :cross_origin

    helpers do
      # Returns an HTTP status code with an error message.
      #
      # @param [Fixnum] status_code a status code
      # @param [String] error_message an error message
      # @return [Array] the status code and error message
      def error(status_code, error_message)
        content_type 'application/json'
        [status_code, JSON.dump({status: status_message(status_code), messages: [{message: error_message}]})]
      end

      def status_message(status_code)
        "#{status_code} #{HTTP_STATUS_CODES.fetch(status_code)}"
      end

      # Validates MQL parameters.
      #
      # @param [Hash] parameters the MQL parameters
      # @return [String,nil] an error message, or nil
      def validate(parameters)
        if !parameters.is_a?(Hash)
          "query is invalid: expected Hash, got #{parameters.class.name}"
        elsif !parameters.key?('query')
          "'query' must be provided"
        elsif !parameters['query'].is_a?(Hash)
          "'query' is invalid: expected Hash, got #{parameters['query'].class.name}"
        end
      end

      # Returns an HTTP/HTTPS client.
      #
      # @return [Faraday::Connection] an HTTP/HTTPS client
      def client
        @client ||= Faraday.new do |connection|
          connection.request :url_encoded

          connection.use FaradayMiddleware::Gzip

          if ENV['MEMCACHIER_SERVERS']
            connection.response :caching do
              ActiveSupport::Cache::MemCacheStore.new(ENV['MEMCACHIER_SERVERS'], {
                expires_in: 3600, # 1 hour
                value_max_bytes: Integer(2097152), # 2 MB, OpenDuka can respond with >1 MB
                username: ENV['MEMCACHIER_USERNAME'],
                password: ENV['MEMCACHIER_PASSWORD'],
              })
            end
          end

          connection.adapter :typhoeus
        end
      end

      # Sets the `Content-Type` and `ETag` headers and returns the response as a JSON string.
      #
      # @param [Hash] a JSON-serializable hash
      # @return [String] a JSON string
      def etag_and_return(response)
        content_type 'application/json'
        etag Digest::MD5.hexdigest(response.inspect)
        JSON.dump(response)
      end
    end

    get '/' do
      redirect 'https://influencemapping.github.io/whos_got_dirt-server/'
    end

    route :get, :post, '/entities' do
      handle_with(:Entity)
    end

    route :get, :post, '/relations' do
      handle_with(:Relation)
    end

    route :get, :post, '/lists' do
      handle_with(:List)
    end

    def handle_with(mod)
      request_module = WhosGotDirt::Requests.const_get(mod)
      response_module = WhosGotDirt::Responses.const_get(mod)

      if !params.key?('queries')
        return error(422, "parameter 'queries' must be provided")
      end
      if params['queries'].nil? || params['queries'].empty?
        return error(422, "parameter 'queries' can't be blank")
      end
      begin
        data = JSON.load(params['queries'])
      rescue JSON::ParserError => e
        return error(400, "parameter 'queries' is invalid: invalid JSON: #{e.message}")
      end
      if !data.is_a?(Hash)
        return error(422, "parameter 'queries' is invalid: expected Hash, got #{data.class.name}")
      end

      manager = Typhoeus::Hydra.new
      queries = {
        status: status_message(200),
      }
      responses = []

      client.in_parallel(manager) do
        begin
          data.each do |query_id,parameters|
            error_message = validate(parameters)
            if error_message
              queries[query_id] = {count: 0, result: [], messages: [{message: error_message}]}
            else
              queries[query_id] = {count: 0, result: [], messages: []}

              query = parameters.fetch('query')

              if parameters.key?('endpoints')
                endpoints = []
                parameters['endpoints'].each do |constant|
                  # Raises "NameError: wrong constant name" if `constant` isn't capitalized.
                  if (request_module.const_defined?(constant) rescue false)
                    endpoints << constant
                  else
                    queries[query_id][:messages] << {message: "endpoint '#{constant}' is not recognized"}
                  end
                end
              else
                endpoints = request_module.constants
              end

              endpoints.each do |api|
                url = request_module.const_get(api).new(query).to_s
                responses << [query_id, api, Faraday.get(url)]
              end
            end
          end
        rescue Faraday::Error::ClientError => e
          return error(502, e.message)
        end
      end

      responses.each do |query_id,api,response|
        result = response_module.const_get(api).new(response)

        if result.success?
          begin
            queries[query_id][:result] += result.to_a
            queries[query_id][:count] += result.count
          # ArgumentError if e.g. Integer() fails in `integer_formatter`
          rescue WhosGotDirt::ValidationError, ArgumentError => e
            queries[query_id][:messages] << {
              info: {
                url: result.env.url,
              },
              status: status_message(500),
              message: "Who's got dirt? Error: #{e.message}",
            }
          end
        else
          queries[query_id][:messages] << {
            info: {
              url: result.env.url,
            },
            status: status_message(result.status),
            message: result.error_message,
          }
        end
      end

      etag_and_return(queries)
    end
  end
end
