require 'rubygems'
require 'bundler/setup'

require 'digest/md5'
require 'json'

require 'faraday'
require 'faraday_middleware'
require 'sinatra'
require 'sinatra/cross_origin'
require 'whos_got_dirt'

configure do
  enable :cross_origin
end

helpers do
  def client
    @client ||= Faraday.new do |connection|
      connection.request :url_encoded
      connection.use FaradayMiddleware::Gzip
      connection.adapter Faraday.default_adapter # must be last
    end
  end

  def etag_and_return(response)
    content_type 'application/json'
    etag(Digest::MD5.hexdigest(response.inspect))
    JSON.dump(response)
  end
end

# @todo support more of Freebase API?
# @see https://developers.google.com/freebase/v1/mqlread
get '/people' do
  hash = {}
  JSON.load(params['queries']).each do |query_id,query|
    # @todo queue different endpoints
    # use class depending on `type`
    # respect `limit`

    url = WhosGotDirt::Requests::People::OpenCorporates.new(query).to_s
    response = Faraday.get(url)
    result = WhosGotDirt::Responses::People::OpenCorporates.new(response)
    hash[query_id] = {
      result: JSON.load(result.body),
    }

    # @todo do slow/polling/postback/email
  end

  etag_and_return(hash)
end

use Rack::Deflater
run Sinatra::Application
