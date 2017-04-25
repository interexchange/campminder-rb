require 'spec_helper'

describe CampMinder do
  it 'has a version number' do
    expect(CampMinder::VERSION).not_to be nil
  end

  it 'has a Business Partner ID' do
    expect(CampMinder::BUSINESS_PARTNER_ID).not_to be nil
  end

  it 'has a Secret Code' do
    expect(CampMinder::SECRET_CODE).not_to be nil
  end

  it 'has a Web Service URL' do
    expect(CampMinder::WEB_SERVICE_URL).not_to be nil
  end

  it 'has a Redirection URL' do
    expect(CampMinder::REDIRECTION_URL).not_to be nil
  end

  describe ".log" do
    subject { CampMinder.log(message) }

    let(:logger) { double }
    let(:message) { "test" }

    before { allow(logger).to receive(:info) }

    context "logger has been set" do
      before { CampMinder.logger = logger }
      after { CampMinder.logger = nil }

      it "sent the message to the logger" do
        subject
        expect(logger).to have_received(:info).with(message)
      end
    end

    context "logger has not been set" do
      before { CampMinder.remove_class_variable("@@logger") }

      it "didn't send the message to the logger" do
        subject
        expect(logger).not_to have_received(:info).with(message)
      end
    end
  end
end
