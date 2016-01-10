require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe do
  def app
    WhosGotDirt::Server
  end

  def data
    JSON.load(last_response.body)
  end

  let :query_without_keys do
    {
      type: 'Person',
      name: 'John Smith',
    }
  end

  let :query_with_keys do
    query_without_keys.merge({
      little_sis_api_key: ENV['LITTLE_SIS_API_KEY'],
      poderopedia_api_key: ENV['PODEROPEDIA_API_KEY'],
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
    describe 'entities' do
      context 'when successful' do
        it 'should return results' do
          VCR.use_cassette('entities_with_keys') do
            send(method, '/entities', queries: JSON.dump(q0: {query: query_with_keys}))
            expect(data.keys).to eq(['status', 'q0'])
            expect(data['status']).to eq('200 OK')
            expect(data['q0'].keys).to eq(['count', 'result', 'messages'])
            expect(data['q0']['count']).to be > 100
            expect(data['q0']['result'].all?{|result| result['@type'] == 'Entity'}).to eq(true)
            expect(data['q0']['messages']).to eq([])
            expect(last_response.status).to eq(200)
            expect(last_response.content_type).to eq('application/json')
          end
        end

        it 'should return results and errors' do
          VCR.use_cassette('entities_without_keys') do
            send(method, '/entities', queries: JSON.dump(q0: {query: query_without_keys}))
            expect(data.keys).to eq(['status', 'q0'])
            expect(data['status']).to eq('200 OK')
            expect(data['q0'].keys).to eq(['count', 'result', 'messages'])
            expect(data['q0']['count']).to be > 100
            expect(data['q0']['result'].all?{|result| result['@type'] == 'Entity'}).to eq(true)
            expect(data['q0']['messages']).to eq([{
              'info' => {
                'url' => 'https://api.littlesis.org/entities.xml?q=John+Smith',
              },
              'status' => '401 Unauthorized',
              'message' => 'Your request must include a query parameter named "_key" with a valid API key value. To obtain an API key, visit http://api.littlesis.org/register.',
            }, {
              'info' => {
                'url' => 'http://api.poderopedia.org/visualizacion/search?alias=John+Smith&entity=persona',
              },
              'status' => '400 Bad Request',
              'message' => '400 BAD REQUEST',
            }])
            expect(last_response.status).to eq(200)
            expect(last_response.content_type).to eq('application/json')
          end
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
