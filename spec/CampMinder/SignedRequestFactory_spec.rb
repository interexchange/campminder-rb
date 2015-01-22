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

  describe '#get_payload' do
    it 'decodes the last part of payload' do
      payload = "Hello World"
      encoded_payload = Base64.encode64(payload)
      signed_payload = "ABC.#{encoded_payload}"

      expect(@signed_request_factory.get_payload(signed_payload)).to eq payload
    end
  end
end
