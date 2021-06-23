require 'rails_helper'

RSpec.describe StockyService do
  describe '.host_uri' do
    before { allow(Figaro.env).to receive(:STOCKY_HOST).and_return('http://stocky') }
    it 'should return Stocky Host' do
      expect(described_class.host_uri).to eq('http://stocky')
    end
  end

  describe '.basic_auth' do
    let(:basic_auth) { { username: 'user', password: 'pass' } }

    before do
      allow(Figaro.env).to receive(:STOCKY_USERNAME).and_return(basic_auth[:username])
      allow(Figaro.env).to receive(:STOCKY_PASSWORD).and_return(basic_auth[:password])
    end

    it 'should return basic auth object' do
      expect(described_class.basic_auth).to eq(basic_auth)
    end
  end

  describe '.get_daily_series' do
    context 'success on fetching data' do
      before do
        allow(Figaro.env).to receive(:STOCKY_HOST).and_return('http://stocky')
        allow(Figaro.env).to receive(:STOCKY_USERNAME).and_return('user')
        allow(Figaro.env).to receive(:STOCKY_PASSWORD).and_return('pass')
      end

      it 'return the stock data' do
        stub_get = stub_request(:get, 'http://stocky/time-series/AAPL/dailies').with(basic_auth: %w(user pass)).to_return(body: '{}', status: 200, headers: {content_type: 'application/json'})

        described_class.get_daily_series('AAPL')
        assert_requested(stub_get)
      end
    end

    context 'fail on fetching data' do
      before do
        allow(Figaro.env).to receive(:STOCKY_HOST).and_return('http://stocky')
        allow(Figaro.env).to receive(:STOCKY_USERNAME).and_return('user')
        allow(Figaro.env).to receive(:STOCKY_PASSWORD).and_return('pass')
      end

      it 'return the stock data' do
        stub_get = stub_request(:get, 'http://stocky/time-series/AAPL/dailies').with(basic_auth: %w(user pass)).to_return(status: [500, 'Internal Server Error'])

        resp = described_class.get_daily_series('AAPL')
        assert_requested(stub_get)
        expect(resp).to be_nil
      end
    end
  end
end
