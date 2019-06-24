RSpec.describe Findchips::Legacy::Client do
  let(:client) do
    if Findchips.auth_token.nil?
      Findchips.configure do |config|
        config.auth_token = 'secret_token'
      end
    end

    Findchips::Legacy::Client.new
  end

  describe '.new' do
    it 'raises an error with a nil auth_token' do
      expect{ Findchips::Legacy::Client.new }.to raise_error(ArgumentError)
    end

    it 'raises an error with a blank auth_token' do
      Findchips.configure do |config|
        config.auth_token = ''
      end

      expect{ Findchips::Legacy::Client.new }.to raise_error(ArgumentError)
    end

    it 'returns a client' do
      expect(client).to be_a(Findchips::Legacy::Client)
    end

    it 'responds_to :search' do
      expect(client).to respond_to(:search)
    end
  end

  describe '#search' do
    it 'gets a 200, with a bad auth_token' do
      Findchips.configure do |config|
        config.auth_token = 'bad_token'
      end

      body = {"metadata"=>{"queryTime"=>"0 ms",
                           "timeStamp"=>"2019-06-26 14:14:01 UTC",
                           "message"=>"Invalid apiKey",
                           "debug"=>false,
                           "requestData"=>{"apiKey"=>"bad_token",
                                           "part"=>"LM741",
                                           "limit"=>15,
                                           "exactMatch"=>false,
                                           "startWith"=>false,
                                           "softWaitTime"=>1000,
                                           "hardWaitTime"=>2500,
                                           "useHardWait"=>false,
                                           "hostedOnly"=>false,
                                           "authorizedOnly"=>false},
                                           "outgoingRequestMap"=>{}},
      "response"=>[]}

      stub_request(:get, "https://api.findchips.com/v1/search?apiKey=bad_token&part=LM741").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'api.findchips.com',
            'User-Agent'=>'Ruby'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

          expect(client.search('LM741')).to eq(body)
    end

    it 'gets a 200, with a good auth_token, and search no responses' do
      body = {"metadata"=>{"queryTime"=>"933 ms",
                           "timeStamp"=>"2019-06-26 16:04:36 UTC",
                           "message"=>"",
                           "debug"=>false,
                           "requestData"=>{"apiKey"=>"secret_token",
                                           "part"=>"8q9q9",
                                           "limit"=>15,
                                           "exactMatch"=>false,
                                           "startWith"=>false,
                                           "softWaitTime"=>1000,
                                           "hardWaitTime"=>2500,
                                           "useHardWait"=>false,
                                           "hostedOnly"=>false,
                                           "authorizedOnly"=>false},
                                           "outgoingRequestMap"=>{}},
      "response"=>[]}

      stub_request(:get, "https://api.findchips.com/v1/search?apiKey=secret_token&part=8q9q9").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'api.findchips.com',
            'User-Agent'=>'Ruby'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

          expect(client.search('8q9q9')).to eq(body)
    end

    it 'gets a 200, with a good auth_token, and search with returns' do
      body = JSON.parse(File.read('spec/fixtures/large_response.json'))

      stub_request(:get, "https://api.findchips.com/v1/search?apiKey=secret_token&part=LM741").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'api.findchips.com',
            'User-Agent'=>'Ruby'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

          expect(client.search('LM741')).to eq(JSON.parse(File.read('spec/fixtures/large_response.json')))
    end
  end
end
