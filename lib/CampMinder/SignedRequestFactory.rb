class CampMinder::SignedRequestFactory
  include Virtus.model

  attribute :secret_code, String, writer: :private, reader: :private

  def initialize(secret_code)
    @secret_code = secret_code
  end

  def is_valid_request?(signed_request)
    encoded_signature, encoded_payload = signed_request.split(".")
    encoded_signature === encode_signature(encoded_payload)
  end

  def get_payload(signed_payload)
    CampMinder::Base64.urlsafe_decode64(signed_payload.split(".").last)
  end

  def encode_signature(encoded_payload)
    CampMinder::Base64.urlsafe_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), @secret_code, encoded_payload)).strip()
  end

  def sign_payload(payload)
    encoded_payload = CampMinder::Base64.urlsafe_encode64(payload)
    encoded_signature = encode_signature(encoded_payload)
    "#{encoded_signature}.#{encoded_payload}"
  end
end
