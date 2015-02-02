require "spec_helper"

describe "StaffHire" do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  before do
    @data = {
      "unique_key" => "1",
      "first_name" => "Draco",
      "middle_initial" => "",
      "last_name" => "Malfoy",
      "email" => "malfoy@example.com",
      "gender" => "1",
      "dob" => "2013-02-27",
      "birth_place" => "London",
      "citizenship" => "United Kingdom",
      "address1" => "Hogwarts",
      "city" => "London",
      "state_province" => "London",
      "postal_code" => "11111",
      "country" => "United Kingdom",
      "agency_member_number" => "FM-1234",
      "hire_date" => "2015-02-12",
      "employment_start_date" => "2015-06-15",
      "employment_end_date" => "2015-08-15",
      "marital_status" => "4",
      "stipend" => "1,500",
      "agency_fee" => "400",
      "smoking" => "true",
      "foreign_languages" => "Mandarin, Australian"
    }
  end

  describe "success" do
    it "responds with success" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)

      post "/camp_minder_staff_hire", @data

      @success = {
        "type" => "success",
        "message" => "Staff Hire successfully added to CampMinder"
      }

      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to eq @success
    end

    it "Creates a CampMinderStaffHire" do
      expect_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(true)

      post "/camp_minder_staff_hire", @data
    end
  end

  describe "failure" do
    it "responds with failure" do
      allow_any_instance_of(DummyCampMinderStaffHireController).to receive(:store_staff_hire).and_return(false)

      post "/camp_minder_staff_hire", @data

      @failure = {
        "type" => "failure",
        "message" => "Staff Hire could not be completed with CampMinder"
      }

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to eq @failure
    end

    it "throws an error when store_staff_hire is unimplemented" do
      expect do
        post "/camp_minder_staff_hire", @data
      end.to raise_error NotImplementedError
    end
  end
end
