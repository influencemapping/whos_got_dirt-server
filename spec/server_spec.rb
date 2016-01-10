require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe do
  def app
    WhosGotDirt::Server
  end

  def data
    JSON.load(last_response.body)
  end

  let :queries do
    JSON.dump({
      q0: {
        query: {
          name: 'John Smith',
          type: 'Person',
          little_sis_api_key: ENV['LITTLE_SIS_API_KEY'],
          poderopedia_api_key: ENV['PODEROPEDIA_API_KEY'],
        },
      },
    })
  end

  it 'should redirect root path' do
    get '/'
    expect(last_response.status).to eq(302)
    expect(last_response.headers['Location']).to eq('https://influencemapping.github.io/whos_got_dirt-server/')
  end

  it 'should 404 on unknown endpoint' do
    get '/unknown'
    expect(last_response.status).to eq(404)
  end

  [:get, :post].each do |method|
    describe 'entities', vcr: {cassette_name: 'entities'} do
      context 'when successful' do
        it 'should return results' do
          send(method, '/entities', queries: queries)
          expect(data.keys).to eq(['status', 'q0'])
          expect(data['status']).to eq('200 OK')
          expect(data['q0'].keys).to eq(['count', 'result', 'messages'])
          expect(data['q0']['messages']).to eq([])
          expect(data['q0']['result'].all?{|result| result['@type'] == 'Entity'}).to eq(true)
          expect(data['q0']['count']).to be > 100
          expect(last_response.status).to eq(200)
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context "when validating 'queries' parameter" do
        it "should 422 on missing 'queries'" do
          send(method, '/entities')
          expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' must be provided"}]})
          expect(last_response.status).to eq(422)
          expect(last_response.content_type).to eq('application/json')
        end

        it "should 422 on nil 'queries'" do
          send(method, '/entities?queries')
          expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' can't be blank"}]})
          expect(last_response.status).to eq(422)
          expect(last_response.content_type).to eq('application/json')
        end

        it "should 422 on empty 'queries'" do
          send(method, '/entities', queries: '')
          expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' can't be blank"}]})
          expect(last_response.status).to eq(422)
          expect(last_response.content_type).to eq('application/json')
        end

        it 'should 400 on invalid JSON' do
          send(method, '/entities', queries: '[')
          expect(data).to eq({'status' => '400 Bad Request', 'messages' => [{'message' => "parameter 'queries' is invalid: invalid JSON: 399: unexpected token at ''"}]})
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end

        it "should 400 on non-Hash 'queries'" do
          send(method, '/entities', queries: '[]')
          expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' is invalid: expected Hash, got Array"}]})
          expect(last_response.status).to eq(422)
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context "when validating MQL parameters" do
        it "should error on non-Hash query" do
          send(method, '/entities', queries: '{"q0":[]}')
          expect(data).to eq({'status' => '200 OK', 'q0' => {'count' => 0, 'result' => [], 'messages' => [{'message' => "query is invalid: expected Hash, got Array"}]}})
          expect(last_response.status).to eq(200)
          expect(last_response.content_type).to eq('application/json')
        end

        it "should error on missing 'query'" do
          send(method, '/entities', queries: '{"q0":{}}')
          expect(data).to eq({'status' => '200 OK', 'q0' => {'count' => 0, 'result' => [], 'messages' => [{'message' => "'query' must be provided"}]}})
          expect(last_response.status).to eq(200)
          expect(last_response.content_type).to eq('application/json')
        end

        it "should error on non-Hash 'query'" do
          send(method, '/entities', queries: '{"q0":{"query":[]}}')
          expect(data).to eq({'status' => '200 OK', 'q0' => {'count' => 0, 'result' => [], 'messages' => [{'message' => "'query' is invalid: expected Hash, got Array"}]}})
          expect(last_response.status).to eq(200)
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end
end
