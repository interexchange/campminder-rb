require "spec_helper"

describe "CampMinderHandler" do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  describe "ClientLinkRequest" do
    before do
      Timecop.freeze(Time.now)

      @signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)

      success_base64_time = CampMinder::Base64.urlsafe_encode64((Time.now.utc + 10).iso8601.to_s)
      @success_signed_object = "#{@signed_request_factory.encode_signature(success_base64_time)}.#{success_base64_time}"

      failure_base64_time = CampMinder::Base64.urlsafe_encode64((Time.now.utc - 10).iso8601.to_s)
      @failure_signed_object = "#{@signed_request_factory.encode_signature(failure_base64_time)}.#{failure_base64_time}"

      @username = "johndoe"
      @password = "secret"
      @partner_client_id = "PC-100"
      @client_id = "C-123"
      @person_id = "P-123"
      @token = "DEF-456"
      @connection_status = true
    end

    after do
      Timecop.return
    end

    it "redirects with success on all good" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).with(@username, @password).and_return(true)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:partner_client_id).and_return(@partner_client_id)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:store_partner_client).with(@partner_client_id, @client_id, @person_id, @token, @connection_status).and_return(true)

      VCR.use_cassette "ClientLinkRequestSuccess", erb: true do
        post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
      end

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=true&reason="
    end

    it "redirects with failure on invalid time" do
      post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @failure_signed_object, token: @token, clientID: @client_id, personID: @person_id

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=false&reason=Invalid GetLinkRequest - signature was invalid!"
    end

    it "redirects with failure on EstablishConnection failure" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(true)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:partner_client_id).and_return(@partner_client_id)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:store_partner_client).and_return(true)

      VCR.use_cassette "ClientLinkRequestEstablishConnectionFailure", erb: true do
        post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
      end

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=false&reason=Unknown"
    end

    it "redirects with failure on valid_username_password? returning false" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(false)

      post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=false&reason=invalid username and password"
    end

    it "redirects with failure on partner_client_id returning nil" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(true)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:partner_client_id).and_return(nil)

      post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=false&reason=partner client id not found"
    end

    it "redirects with failure on store_partner_client failure" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(true)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:partner_client_id).and_return(@partner_client_id)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:store_partner_client).and_return(false)

      VCR.use_cassette "ClientLinkRequestSuccess", erb: true do
        post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
      end

      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=false&reason=failed to save partner client"
    end

    it "throws an error when valid_username_password? is unimplemented" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:store_partner_client).and_return(true)

      expect do
        VCR.use_cassette "ClientLinkRequestSuccess", erb: true do
          post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
        end
      end.to raise_error NotImplementedError
    end

    it "throws an error when partner_client_id is unimplemented" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(true)
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:store_partner_client).and_return(true)

      expect do
        VCR.use_cassette "ClientLinkRequestSuccess", erb: true do
          post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
        end
      end.to raise_error NotImplementedError
    end

    it "throws an error when store_partner_client is unimplemented" do
      allow_any_instance_of(DummyCampMinderHandlerController).to receive(:valid_username_password?).and_return(true)

      expect do
        VCR.use_cassette "ClientLinkRequestSuccess", erb: true do
          post "/camp_minder_handler", fn: "ClientLinkRequest", username: @username, password: @password, signedObject: @success_signed_object, token: @token, clientID: @client_id, personID: @person_id
        end
      end.to raise_error NotImplementedError
    end
  end

  describe "ServerTimeGet" do
    before do
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    it "responds with server time" do
      post "/camp_minder_handler", fn: "ServerTimeGet"

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq %{<?xml version="1.0" encoding="UTF-8"?>
<responseObject>
  <status>True</status>
  <details>ServerTimeGet</details>
  <data>#{Time.now.utc.iso8601.to_s}</data>
</responseObject>
}
    end
  end
end
