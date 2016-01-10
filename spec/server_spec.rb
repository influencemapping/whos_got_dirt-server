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

  describe 'entities', vcr: {cassette_name: 'entities'} do
    context 'when successful' do
      it 'should return results for GET request' do
        get '/entities', queries: queries
        expect(data.keys).to eq(['q0'])
        expect(data['q0'].keys).to eq(['count', 'result', 'messages'])
        expect(data['q0']['messages']).to eq([])
        expect(data['q0']['result'].all?{|result| result['@type'] == 'Entity'}).to eq(true)
        expect(data['q0']['count']).to be > 100
        expect(last_response.status).to eq(200)
      end

      it 'should return results for POST request' do
        post '/entities', queries: queries
        expect(data.keys).to eq(['q0'])
        expect(data['q0'].keys).to eq(['count', 'result', 'messages'])
        expect(data['q0']['messages']).to eq([])
        expect(data['q0']['result'].all?{|result| result['@type'] == 'Entity'}).to eq(true)
        expect(data['q0']['count']).to be > 100
        expect(last_response.status).to eq(200)
      end
    end

    context "when validating 'queries' parameter" do
      it "should 422 on missing 'queries'" do
        get '/entities'
        expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' must be provided"}]})
        expect(last_response.status).to eq(422)
      end

      it "should 422 on nil 'queries'" do
        get '/entities?queries'
        expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' can't be blank"}]})
        expect(last_response.status).to eq(422)
      end

      it "should 422 on empty 'queries'" do
        get '/entities', queries: ''
        expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' can't be blank"}]})
        expect(last_response.status).to eq(422)
      end

      it 'should 400 on invalid JSON' do
        get '/entities', queries: '['
        expect(data).to eq({'status' => '400 Bad Request', 'messages' => [{'message' => "parameter 'queries' is invalid: invalid JSON: 399: unexpected token at ''"}]})
        expect(last_response.status).to eq(400)
      end

      it "should 400 on non-Hash 'queries'" do
        get '/entities', queries: '[]'
        expect(data).to eq({'status' => '422 Unprocessable Entity', 'messages' => [{'message' => "parameter 'queries' is invalid: expected Hash, got Array"}]})
        expect(last_response.status).to eq(422)
      end
    end

    context "when validating MQL parameters" do
      it "should error on non-Hash query" do
        get '/entities', queries: '{"q0":[]}'
        expect(data).to eq({'q0' => {'messages' => [{'message' => "query is invalid: expected Hash, got Array"}]}})
        expect(last_response.status).to eq(200)
      end

      it "should error on missing 'query'" do
        get '/entities', queries: '{"q0":{}}'
        expect(data).to eq({'q0' => {'messages' => [{'message' => "'query' must be provided"}]}})
        expect(last_response.status).to eq(200)
      end

      it "should error on non-Hash 'query'" do
        get '/entities', queries: '{"q0":{"query":[]}}'
        expect(data).to eq({'q0' => {'messages' => [{'message' => "'query' is invalid: expected Hash, got Array"}]}})
        expect(last_response.status).to eq(200)
      end
    end
  end

  it 'should 404 on unknown endpoint' do
    get '/unknown'
    expect(last_response.status).to eq(404)
  end
end
