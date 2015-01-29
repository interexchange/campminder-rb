require 'spec_helper'

describe CampMinder::SignedRequestFactory do
  before do
    @signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
  end

  describe '#initialize' do
    it 'initializes with secret attribute' do
      expect(@signed_request_factory).to be_an_instance_of CampMinder::SignedRequestFactory
      expect(@signed_request_factory.send(:secret_code)).to eq CampMinder::SECRET_CODE
    end

    it 'protects the secret_code' do
      expect do
        expect(@signed_request_factory.public_send(:secret_code)).to eq CampMinder::SECRET_CODE
      end.to raise_error NoMethodError
    end

    it 'initializes with secret attribute' do
      expect do
        CampMinder::SignedRequestFactory.new
      end.to raise_error ArgumentError
    end
  end

  describe '#is_valid_request?' do
    before do
      @payload = "Hello World"
      @encoded_payload = Base64.strict_encode64(@payload)
    end

    it 'returns true if payload signed with SECRET_CODE' do
      @encoded_signature = @signed_request_factory.encode_signature(@encoded_payload)
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
      expect(@signed_request_factory.is_valid_request?(@signed_payload)).to eq true
    end

    it 'returns false if payload not signed with SECRET_CODE' do
      signed_request_factory = CampMinder::SignedRequestFactory.new('lol')
      @encoded_signature = signed_request_factory.encode_signature(@encoded_payload)
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
      expect(@signed_request_factory.is_valid_request?(@signed_payload)).to eq false
    end
  end

  describe '#get_payload' do
    before do
      @payload = "Hello World"
      @encoded_payload = Base64.strict_encode64(@payload)
      @encoded_signature = "ABC"
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
    end

    it 'decodes the last part of payload' do
      expect(@signed_request_factory.get_payload(@signed_payload)).to eq @payload
    end
  end

  describe '#prepare_decode_base64' do
    it 'pads to mod 4' do
      expect(@signed_request_factory.prepare_decode_base64('AB')).to eq 'AB=='
      expect(@signed_request_factory.prepare_decode_base64('ABCD')).to eq 'ABCD'
      expect(@signed_request_factory.prepare_decode_base64('ABCDE')).to eq 'ABCDE==='
    end

    it 'replaces - with +' do
      expect(@signed_request_factory.prepare_decode_base64('-+++')).to eq '++++'
    end

    it 'replaces _ with /' do
      expect(@signed_request_factory.prepare_decode_base64('_///')).to eq '////'
    end
  end

  describe '#prepare_encoded_base64' do
    it 'removes =' do
      expect(@signed_request_factory.prepare_encoded_base64('AB==')).to eq 'AB'
    end

    it 'replaces + with -' do
      expect(@signed_request_factory.prepare_encoded_base64('-+++')).to eq '----'
    end

    it 'replaces / with _' do
      expect(@signed_request_factory.prepare_encoded_base64('_///')).to eq '____'
    end
  end
end
