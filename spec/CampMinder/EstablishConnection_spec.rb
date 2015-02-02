require "spec_helper"

describe CampMinder::EstablishConnection do
  before do
    @data = {
      "client_id" => "C-123",
      "person_id" => "P-123",
      "token" => "DEF-456",
      "partner_client_id" => "IEX-C-123"
    }

    @payload = %{<connectionRequest version="1">
  <clientID>#{@data["client_id"]}</clientID>
  <personID>#{@data["person_id"]}</personID>
  <token>#{@data["token"]}</token>
  <partnerClientID>#{@data["partner_client_id"]}</partnerClientID>
</connectionRequest>
}

    @signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
    @encoded_payload = CampMinder::Base64.urlsafe_encode64(@payload)
    @encoded_signature = @signed_request_factory.encode_signature(@encoded_payload)
    @signed_object = "#{@encoded_signature}.#{@encoded_payload}"

    @establish_connection = CampMinder::EstablishConnection.new(@data)
  end

  describe "#initialize" do
    it "initializes with data attribute" do
      expect(@establish_connection).not_to be nil
    end

    it "assigns the client_id attribute" do
      expect(@establish_connection.client_id).to eq @data["client_id"]
    end

    it "assigns the person_id attribute" do
      expect(@establish_connection.person_id).to eq @data["person_id"]
    end

    it "assigns the token attribute" do
      expect(@establish_connection.token).to eq @data["token"]
    end

    it "assigns the partner_client_id attribute" do
      expect(@establish_connection.partner_client_id).to eq @data["partner_client_id"]
    end

    it "raises an exception on missing attributes" do
      data_without_clientid = @data.tap { |data| data.delete("client_id") }

      expect do
        CampMinder::EstablishConnection.new(data_without_clientid)
      end.to raise_error KeyError
    end
  end

  describe "#payload" do
    it "generates an xml payload" do
      expect(@establish_connection.payload).to eq @payload
    end
  end

  describe "#signed_object" do
    it "signs the connection request" do
      expect(@establish_connection.signed_object).to eq @signed_object
    end
  end

  describe "#post" do
    before do
      @form_params = {
        "fn" => "EstablishConnection",
        "businessPartnerID" => CampMinder::BUSINESS_PARTNER_ID,
        "signedObject" => @signed_payload
      }
    end

    it "sends a successful connection post request to CampMinder" do
      VCR.use_cassette "EstablishConnectionSuccess", erb: true do
        expect(@establish_connection.post).to be true
        expect(@establish_connection.connection_failure_details).to be nil
      end
    end

    it "uses a proxy url if CAMPMINDER_PROXY_URL is set" do
      CampMinder::PROXY_URL = "http://proxy.example:3128"
      uri = URI.parse(CampMinder::WEB_SERVICE_URL)
      proxy_uri = URI.parse(CampMinder::PROXY_URL)

      expect(Net::HTTP).to receive(:new).with(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password).and_call_original

      VCR.use_cassette "EstablishConnectionProxySuccess", erb: true do
        expect(@establish_connection.post).to be true
        expect(@establish_connection.connection_failure_details).to be nil
      end
    end

    it "sends a failed connection post request to CampMinder" do
      VCR.use_cassette "EstablishConnectionFailure", erb: true do
        expect(@establish_connection.post).to be false
        expect(@establish_connection.connection_failure_details).to eq "Unknown"
      end
    end
  end
end
