RSpec.describe Findchips do
  describe '.auth_token' do
    it 'defaults to nil' do
      expect(Findchips.auth_token).to be_nil
    end

    it 'sets the auth token within a config block' do
      Findchips.configure do |config|
        config.auth_token = 'secret_token'
      end

      expect(Findchips.auth_token).to eq('secret_token')
    end
  end
end
