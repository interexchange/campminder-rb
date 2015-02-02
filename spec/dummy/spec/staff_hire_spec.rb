require "spec_helper"

describe "StaffHire" do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  before do
    @data = {
      "client_id" => "CID-1",
      "token" => "TOKENLOL",
      "partner_client_id" => "PCID-1",
      "unique_key" => "1",
      "first_name" => "draco",
      "middle_initial" => "",
      "last_name" => "malfoy",
      "email" => "malfoy@example.com",
      "gender" => "1",
      "dob" => "2013-02-27",
      "birth_place" => "london",
      "citizenship" => "united kingdom",
      "address1" => "hogwarts",
      "city" => "london",
      "state_province" => "london",
      "postal_code" => "11111",
      "country" => "united kingdom",
      "permanent_phone" => "999 999 9999",
      "agency_member_number" => "fm-1234",
      "hire_date" => "2015-02-12",
      "employment_start_date" => "2015-06-15",
      "employment_end_date" => "2015-08-15",
      "marital_status" => "4",
      "base_salary" => "1,500",
      "agency_fee" => "400",
      "smoking" => "true",
      "foreign_languages" => "mandarin, australian"
    }

    @success_response = {
      "type" => "success",
      "message" => "Staff Hire successfully added to CampMinder"
    }

    @failure_response = {
      "type" => "failure",
      "message" => "Staff Hire could not be completed with CampMinder"
    }
  end

  describe "success" do
    it "makes a StaffHire request to CampMinder" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)

      VCR.use_cassette "StaffHireSuccess", erb: true do
        post "/camp_minder_staff_hire", @data
      end
    end

    it "responds with success" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)
      allow_any_instance_of(CampMinder::StaffHire).to receive(:post).and_return(true)

      post "/camp_minder_staff_hire", @data

      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to eq @success_response
    end

    it "Creates a CampMinderStaffHire" do
      expect_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)
      allow_any_instance_of(CampMinder::StaffHire).to receive(:post).and_return(true)

      post "/camp_minder_staff_hire", @data
    end
  end

  describe "failure" do
    it "responds with failure on store_staff_hire failure" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)
      allow_any_instance_of(CampMinder::StaffHire).to receive(:post).and_return(false)

      post "/camp_minder_staff_hire", @data

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to eq @failure_response
    end

    it "responds with failure on store_staff_hire failure" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(false)
      allow_any_instance_of(CampMinder::StaffHire).to receive(:post).and_return(true)

      post "/camp_minder_staff_hire", @data

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to eq @failure_response
    end

    it "throws an error when store_staff_hire is unimplemented" do
      allow_any_instance_of(CampMinder::StaffHire).to receive(:post).and_return(true)

      expect do
        post "/camp_minder_staff_hire", @data
      end.to raise_error NotImplementedError
    end
  end
end
