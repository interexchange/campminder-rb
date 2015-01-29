require 'spec_helper'

describe CampMinder::Base64 do
  describe ".urlsafe_encode64" do
    it "encodes the payload in base64" do
      expect(Base64).to receive(:urlsafe_encode64).and_return("LOLOL===")
      expect(CampMinder::Base64.urlsafe_encode64("lol")).to eq "LOLOL"
    end
  end

  describe '.urlsafe_decode64' do
    it "decodes the base64 payload" do
      expect(Base64).to receive(:urlsafe_decode64).with("l===")
      CampMinder::Base64.urlsafe_decode64("l")

      expect(Base64).to receive(:urlsafe_decode64).with("lolo")
      CampMinder::Base64.urlsafe_decode64("lolo")

      expect(Base64).to receive(:urlsafe_decode64).with("lol=")
      CampMinder::Base64.urlsafe_decode64("lol")

      expect(Base64).to receive(:urlsafe_decode64).with("lo==")
      CampMinder::Base64.urlsafe_decode64("lo")
    end
  end
end
