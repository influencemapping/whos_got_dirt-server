require 'digest/md5'
require 'json'

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'sinatra'
require 'sinatra/cross_origin'
require 'whos_got_dirt'

module WhosGotDirt
  class Server < Sinatra::Base
    # Maps a class to the APIs to query.
    # @todo https://github.com/influencemapping/whos_got_dirt-server/issues/11
    APIS = {
      'Person' => [
        :OpenCorporates,
        # @todo
      ],
      'Organization' => [
        :OpenCorporates,
        # @todo
      ],
    }

    configure do
      enable :cross_origin
    end

    helpers do
      # Returns an HTTP status code with an error message.
      #
      # @param [Fixnum] status_code a status code
      # @param [String] error_message an error message
      # @return [Array] the status code and error message
      def error(status_code, error_message)
        [status_code, JSON.dump({error: {message: error_message}})]
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
        elsif !parameters['query'].key?('type')
          "query 'type' must be provided"
        elsif !parameters['query']['type'].is_a?(String)
          "query 'type' is invalid: expected String, got #{parameters['query']['type'].class.name}"
        elsif !%w(Person Organization).include?(parameters['query']['type'])
          "query 'type' is invalid: expected 'Person' or 'Organization', got '#{parameters['query']['type']}'"
        end
      end

      # Returns an HTTP/HTTPS client.
      #
      # @return [Faraday::Connection] an HTTP/HTTPS client
      def client
        @client ||= Faraday.new do |connection|
          connection.request :url_encoded
          connection.use FaradayMiddleware::Gzip
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

    get '/people' do
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
      queries = {}
      responses = []

      client.in_parallel(manager) do
        begin
          data.each do |query_id,parameters|
            error_message = validate(parameters)
            if error_message
              queries[query_id] = {error: {message: error_message}}
            else
              queries[query_id] = {count: 0, result: []}

              query = parameters.fetch('query')
              type = query.delete('type')
              # @todo https://github.com/influencemapping/whos_got_dirt-server/issues/3
              # @todo https://github.com/influencemapping/whos_got_dirt-server/issues/4
              APIS[type].each do |api|
                url = WhosGotDirt::Requests.const_get(type).const_get(api).new(query).to_s
                responses << [query_id, type, api, Faraday.get(url)]
              end
            end
          end
        rescue Faraday::Error::ClientError => e
          return [502, {error: {message: e.message}}]
        end
      end

      responses.each do |query_id,type,api,response|
        if response.success?
          result = WhosGotDirt::Responses.const_get(type).const_get(api).new(response)
          queries[query_id][:count] += result.count
          queries[query_id][:result] += result.to_a
        else
          queries[query_id] = {error: {message: response.body}}
        end
      end

      etag_and_return(queries)
    end
  end
end
