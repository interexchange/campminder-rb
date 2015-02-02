require "spec_helper"

describe "StaffHire" do
  before do
    @data = {
      "client_id" => "153",
      "token" => "f2e8602d-a9fe-4da3-b817-c8264751a829",
      "partner_client_id" => "6375",
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

    @payload = %{<staffDataContainer version="1">
  <cmClientId>#{@data["client_id"]}</cmClientId>
  <token>#{@data["token"]}</token>
  <partnerClientId>#{@data["partner_client_id"]}</partnerClientId>
  <staffDataArray>
    <staffData version="1">
      <uniqueKey>#{@data["unique_key"]}</uniqueKey>
      <firstName>#{@data["first_name"]}</firstName>
      <lastName>#{@data["last_name"]}</lastName>
      <gender>#{@data["gender"]}</gender>
      <dob>#{@data["dob"]}</dob>
      <birthPlace>#{@data["birth_place"]}</birthPlace>
      <citizenship>#{@data["citizenship"]}</citizenship>
      <address1>#{@data["address1"]}</address1>
      <city>#{@data["city"]}</city>
      <isStateProvinceRequired>true</isStateProvinceRequired>
      <stateProvince>#{@data["state_province"]}</stateProvince>
      <isPostalCodeRequired>true</isPostalCodeRequired>
      <postalCode>#{@data["postal_code"]}</postalCode>
      <country>#{@data["country"]}</country>
      <email>#{@data["email"]}</email>
      <agencyMemberNumber>#{@data["agency_member_number"]}</agencyMemberNumber>
      <address2/>
      <middleInitial>#{@data["middle_initial"]}</middleInitial>
      <nickName/>
      <nationalID/>
      <licenseState/>
      <licenseNumber/>
      <permanentPhone>#{@data["permanent_phone"]}</permanentPhone>
      <schoolPhone/>
      <cellPhone/>
      <workPhone/>
      <otherPhone/>
      <email2/>
      <hireDate>#{@data["hire_date"]}</hireDate>
      <occupationYearAtSchool/>
      <employmentStartDate>#{@data["employment_start_date"]}</employmentStartDate>
      <employmentEndDate>#{@data["employment_end_date"]}</employmentEndDate>
      <school/>
      <schoolAddress1/>
      <schoolAddress2/>
      <schoolCity/>
      <schoolState/>
      <schoolPostalCode/>
      <schoolCountry/>
      <major/>
      <springBreak/>
      <summerBreak/>
      <graduationDate/>
      <extracurricularActivities/>
      <career/>
      <maritalStatus>#{@data["marital_status"]}</maritalStatus>
      <baseSalary>#{@data["base_salary"]}</baseSalary>
      <agencyFee>#{@data["agency_fee"]}</agencyFee>
      <specialTerms/>
      <arrestRecord/>
      <duiRecord/>
      <childAbuseRecord/>
      <smoking>#{@data["smoking"]}</smoking>
      <smallCraftAbility/>
      <cprExpiration/>
      <firstAidExpiration/>
      <lifeguardExpiration/>
      <wsiExpiration/>
      <height/>
      <weight/>
      <wildernessEMTExpiration/>
      <ropesExpiration/>
      <canoeingExpiration/>
      <sailingExpiration/>
      <militaryExperience/>
      <foreignLanguages>#{@data["foreign_languages"]}</foreignLanguages>
      <musicalInstruments/>
    </staffData>
  </staffDataArray>
</staffDataContainer>
}

    @signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
    @encoded_payload = CampMinder::Base64.urlsafe_encode64(@payload)
    @encoded_signature = @signed_request_factory.encode_signature(@encoded_payload)
    @signed_object = "#{@encoded_signature}.#{@encoded_payload}"

    @staff_hire = CampMinder::StaffHire.new(@data)
  end

  describe "#initialize" do
    it "initializes with data attribute" do
      expect(@staff_hire).not_to be nil
    end

    it "doesn't raise an exception on unrequired missing attributes" do
      data_without_unique_key = @data.tap { |data| data.delete("middle_initial") }

      expect do
        CampMinder::StaffHire.new(data_without_unique_key)
      end.not_to raise_error
    end

    it "raises an exception on required missing attributes" do
      data_without_unique_key = @data.tap { |data| data.delete("unique_key") }

      expect do
        CampMinder::StaffHire.new(data_without_unique_key)
      end.to raise_error KeyError
    end
  end

  describe "#payload" do
    it "generates an xml payload" do
      expect(@staff_hire.payload).to eq @payload
    end
  end

  describe "#signed_object" do
    it "signs the staff data" do
      expect(@staff_hire.signed_object).to eq @signed_object
    end
  end

  describe "#post" do
    it "sends a successful StaffHire request to CampMinder" do
      VCR.use_cassette "StaffHireSuccess", erb: true do
        expect(@staff_hire.post).to be true
        expect(@staff_hire.failure_details).to be nil
      end
    end

    it "uses a proxy url if CAMPMINDER_PROXY_URL is set" do
      CampMinder::PROXY_URL = "http://proxy.example:3128"
      uri = URI.parse(CampMinder::WEB_SERVICE_URL)
      proxy_uri = URI.parse(CampMinder::PROXY_URL)

      expect(Net::HTTP).to receive(:new).with(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password).and_call_original

      VCR.use_cassette "StaffHireProxySuccess", erb: true do
        expect(@staff_hire.post).to be true
        expect(@staff_hire.failure_details).to be nil
      end
    end
  end
end
