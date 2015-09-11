require 'rubygems'
require 'bundler/setup'

require 'digest/md5'
require 'json'

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'sinatra'
require 'sinatra/cross_origin'
require 'whos_got_dirt'

# Maps a class to the APIs to query.
APIS = {
  'Person' => [
    :OpenCorporates,
    # @todo
  ],
  'Organization' => [
    # @todo
  ],
}

configure do
  enable :cross_origin
end

helpers do
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
  manager = Typhoeus::Hydra.new
  queries = {}
  responses = []

  client.in_parallel(manager) do
    begin
      JSON.load(params['queries']).each do |query_id,parameters|
        query = parameters['query']
        type = query.delete('type')
        if %w(Person Organization).include?(type)
          queries[query_id] = {count: 0, result: []}
          # @todo https://github.com/influencemapping/whos_got_dirt-server/issues/3
          # @todo https://github.com/influencemapping/whos_got_dirt-server/issues/4
          APIS[type].each do |api|
            url = WhosGotDirt::Requests.const_get(type).const_get(api).new(query).to_s
            responses << [query_id, type, api, Faraday.get(url)]
          end
        else
          queries[query_id] = {error: {message: "unrecognized query type '#{type}'"}}
        end
      end
    rescue Faraday::Error::ClientError => e
      return [500, {error: {message: e.message}}]
    end
  end

  responses.each do |query_id,type,api,response|
    if response.success?
      result = WhosGotDirt::Responses.const_get(type).const_get(api).new(response)
      queries[query_id][:count] += result.count
      queries[query_id][:result] += result.to_a
    end
  end

  etag_and_return(queries)
end

use Rack::Deflater
run Sinatra::Application
