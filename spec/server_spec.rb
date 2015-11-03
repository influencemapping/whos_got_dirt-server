require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe do
  def app
    WhosGotDirt::Server
  end

  def data
    JSON.load(last_response.body)
  end

  describe 'GET people' do
    context 'when successful' do
      it 'should return results' do
        get '/entities', queries: '{"q0":{"query":{"type":"Person","name":"John Smith"}}}'
        expect(data.keys).to eq(['q0'])
        expect(data['q0'].keys).to eq(['count', 'result'])
        expect(data['q0']['count']).to be > 10_000
        expect(data['q0']['result'].all?{|result| result['@type'] == 'Person'}).to eq(true)
        expect(last_response.status).to eq(200)
      end
    end

    context "when validating 'queries' parameter" do
      it "should 422 on missing 'queries'" do
        get '/entities'
        expect(data).to eq({'error' => {'message' => "parameter 'queries' must be provided"}})
        expect(last_response.status).to eq(422)
      end

      it "should 422 on nil 'queries'" do
        get '/entities?queries'
        expect(data).to eq({'error' => {'message' => "parameter 'queries' can't be blank"}})
        expect(last_response.status).to eq(422)
      end

      it "should 422 on empty 'queries'" do
        get '/entities', queries: ''
        expect(data).to eq({'error' => {'message' => "parameter 'queries' can't be blank"}})
        expect(last_response.status).to eq(422)
      end

      it 'should 400 on invalid JSON' do
        get '/entities', queries: '['
        expect(data).to eq({'error' => {'message' => "parameter 'queries' is invalid: invalid JSON: 399: unexpected token at ''"}})
        expect(last_response.status).to eq(400)
      end

      it "should 400 on non-Hash 'queries'" do
        get '/entities', queries: '[]'
        expect(data).to eq({'error' => {'message' => "parameter 'queries' is invalid: expected Hash, got Array"}})
        expect(last_response.status).to eq(422)
      end
    end

    context "when validating MQL parameters" do
      it "should error on non-Hash query" do
        get '/entities', queries: '{"q0":[]}'
        expect(data).to eq({'q0' => {'error' => {'message' => "query is invalid: expected Hash, got Array"}}})
        expect(last_response.status).to eq(200)
      end

      it "should error on missing 'query'" do
        get '/entities', queries: '{"q0":{}}'
        expect(data).to eq({'q0' => {'error' => {'message' => "'query' must be provided"}}})
        expect(last_response.status).to eq(200)
      end

      it "should error on non-Hash 'query'" do
        get '/entities', queries: '{"q0":{"query":[]}}'
        expect(data).to eq({'q0' => {'error' => {'message' => "'query' is invalid: expected Hash, got Array"}}})
        expect(last_response.status).to eq(200)
      end

      it "should error on missing 'type'" do
        get '/entities', queries: '{"q0":{"query":{}}}'
        expect(data).to eq({'q0' => {'error' => {'message' => "query 'type' must be provided"}}})
        expect(last_response.status).to eq(200)
      end

      it "should error on non-String 'type'" do
        get '/entities', queries: '{"q0":{"query":{"type":[]}}}'
        expect(data).to eq({'q0' => {'error' => {'message' => "query 'type' is invalid: expected String, got Array"}}})
        expect(last_response.status).to eq(200)
      end

      it "should error on unknown 'type'" do
        get '/entities', queries: '{"q0":{"query":{"type":"Unknown"}}}'
        expect(data).to eq({'q0' => {'error' => {'message' => "query 'type' is invalid: expected 'Person' or 'Organization', got 'Unknown'"}}})
        expect(last_response.status).to eq(200)
      end
    end
  end

  it 'should 404 on unknown endpoint' do
    get '/unknown'
    expect(last_response.status).to eq(404)
  end
end
