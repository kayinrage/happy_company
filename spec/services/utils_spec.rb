require 'spec_helper'

describe Utils do
  describe '.generate_secret' do
    context 'when no attribute it passed' do
      it 'should generate code from 16 characters' do
        expect(Utils.generate_secret.size).to eq 16
      end
    end

    context 'when attribute is passed and is equal 4' do
      it 'should generate code from 4 characters' do
        expect(Utils.generate_secret(4).size).to eq 4
      end
    end
  end

  describe '.mailer_host' do
    it 'should return correct host' do
      expect(Utils.mailer_host).to eq 'localhost:3000'
    end
  end

  describe '.api_response' do
    it 'should return hash with correct key-values' do
      expect(Utils.api_response('200', 'everything is awesome')).to eq({status: '200', message: 'everything is awesome'})
    end
  end
end
