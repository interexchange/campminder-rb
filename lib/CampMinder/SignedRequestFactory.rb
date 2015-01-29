require 'base64'

class CampMinder::SignedRequestFactory
  include Virtus.model

  PAD_LENGTH = 4

  attribute :secret_code, String, writer: :private, reader: :private

  def initialize(secret_code)
    @secret_code = secret_code
  end

  def is_valid_request?(signed_request)
    encoded_signature, encoded_payload = signed_request.split('.')
    encoded_signature === encode_signature(encoded_payload)
  end

  def get_payload(signed_payload)
    Base64.decode64(prepare_decode_base64(signed_payload.split('.').last))
  end

  def encode_signature(encoded_payload)
    prepare_encoded_base64(Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @secret_code, encoded_payload))).strip
  end

  def sign_payload(payload)
    encoded_payload = prepare_encoded_base64(Base64.strict_encode64(payload))
    encoded_signature = encode_signature(encoded_payload)
    "#{encoded_signature}.#{encoded_payload}"
  end

  def prepare_decode_base64(encoded_payload)
    mod = encoded_payload.length % PAD_LENGTH
    encoded_payload += ('=' * (PAD_LENGTH - mod)) unless mod == 0
    encoded_payload.gsub!('_', '/')
    encoded_payload.gsub!('-', '+')

    encoded_payload
  end

  def prepare_encoded_base64(payload)
    payload.gsub!('=', '')
    payload.gsub!('+', '-')
    payload.gsub!('/', '_')

    payload
  end
end
