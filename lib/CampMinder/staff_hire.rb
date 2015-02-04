class CampMinder::StaffHire
  include Virtus.model

  attribute :client_id, String
  attribute :token, String
  attribute :partner_client_id, String

  attribute :unique_key, String
  attribute :first_name, String
  attribute :middle_initial, String
  attribute :last_name, String
  attribute :email, String
  attribute :gender, String
  attribute :dob, String
  attribute :birth_place, String
  attribute :citizenship, String
  attribute :address1, String
  attribute :city, String
  attribute :state_province, String
  attribute :postal_code, String
  attribute :country, String
  attribute :permanent_phone, String
  attribute :agency_member_number, String
  attribute :hire_date, String
  attribute :employment_start_date, String
  attribute :employment_end_date, String
  attribute :marital_status, String
  attribute :base_salary, String
  attribute :agency_fee, String
  attribute :smoking, String
  attribute :foreign_languages, String
  attribute :address2, String

  attribute :nick_name, String
  attribute :national_id, String
  attribute :license_state, String
  attribute :license_number, String
  attribute :permanent_phone, String
  attribute :school_phone, String
  attribute :cell_phone, String
  attribute :work_phone, String
  attribute :other_phone, String
  attribute :email2, String
  attribute :occupation_year_at_school, String
  attribute :school, String
  attribute :school_address1, String
  attribute :school_address2, String
  attribute :school_city, String
  attribute :school_state, String
  attribute :school_postal_code, String
  attribute :school_country, String
  attribute :major, String
  attribute :spring_break, String
  attribute :summer_break, String
  attribute :graduation_date, String
  attribute :extracurricular_activities, String
  attribute :career, String
  attribute :special_terms, String
  attribute :arrest_record, String
  attribute :dui_record, String
  attribute :child_abuse_record, String
  attribute :smoking, String
  attribute :small_craft_ability, String
  attribute :cpr_expiration, String
  attribute :first_aid_expiration, String
  attribute :lifeguard_expiration, String
  attribute :wsi_expiration, String
  attribute :height, String
  attribute :weight, String
  attribute :wilderness_emt_expiration, String
  attribute :ropes_expiration, String
  attribute :canoeing_expiration, String
  attribute :sailing_expiration, String
  attribute :military_experience, String
  attribute :musical_instruments, String

  attribute :failure_details, String
  attribute :payload, String
  attribute :signed_object, String

  def initialize(args)
    super(args)

    @client_id = args.fetch("client_id")
    @token = args.fetch("token")
    @partner_client_id = args.fetch("partner_client_id")

    @unique_key = args.fetch("unique_key")
    @first_name = args.fetch("first_name")
    @last_name = args.fetch("last_name")
    @email = args.fetch("email")
    @gender = args.fetch("gender")
    @dob = args.fetch("dob")
    @birth_place = args.fetch("birth_place")
    @citizenship = args.fetch("citizenship")
    @address1 = args.fetch("address1")
    @city = args.fetch("city")
    @state_province = args.fetch("state_province")
    @postal_code = args.fetch("postal_code")
    @country = args.fetch("country")
    @agency_member_number = args.fetch("agency_member_number")
  end

  def payload
    @payload = to_xml(skip_instruct: true)
  end

  def signed_object
    signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
    @signed_object = signed_request_factory.sign_payload(payload)
  end

  def post
    uri = URI.parse(CampMinder::WEB_SERVICE_URL)
    http = nil

    if CampMinder::PROXY_URL.present?
      proxy_uri = URI.parse(CampMinder::PROXY_URL)
      http = Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
    else
      http = Net::HTTP.new(uri.host, uri.port)
    end

    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data("fn" => "StaffHire", "businessPartnerID" => CampMinder::BUSINESS_PARTNER_ID, "signedObject" => signed_object)
    response = http.request(request)

    doc = Nokogiri.XML(response.body)
    success = doc.at_xpath("//status").content

    case success
    when "True"
      true
    when "False"
      @failure_details = doc.at_xpath("//details").content
      false
    end
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    builder = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    builder.instruct! unless options[:skip_instruct]
    builder.staffDataContainer(version: "1") do |b|
      b.cmClientId @client_id
      b.token @token
      b.partnerClientId @partner_client_id
      b.staffDataArray do |_b|
        b.staffData(version: "1") do |bi|
          bi.uniqueKey @unique_key
          bi.firstName @first_name
          bi.lastName @last_name
          bi.gender @gender
          bi.dob @dob
          bi.birthPlace @birth_place
          bi.citizenship @citizenship
          bi.address1 @address1
          bi.city @city
          bi.isStateProvinceRequired @state_province.present?
          bi.stateProvince @state_province
          bi.isPostalCodeRequired @postal_code.present?
          bi.postalCode @postal_code
          bi.country @country
          bi.email @email
          bi.agencyMemberNumber @agency_member_number
          bi.address2 @address2
          bi.middleInitial @middle_initial
          bi.nickName @nick_name
          bi.nationalID @national_id
          bi.licenseState @license_state
          bi.licenseNumber @license_number
          bi.permanentPhone @permanent_phone
          bi.schoolPhone @school_phone
          bi.cellPhone @cell_phone
          bi.workPhone @work_phone
          bi.otherPhone @other_phone
          bi.email2 @email2
          bi.hireDate @hire_date
          bi.occupationYearAtSchool @occupation_year_at_school
          bi.employmentStartDate @employment_start_date
          bi.employmentEndDate @employment_end_date
          bi.school @school
          bi.schoolAddress1 @school_address1
          bi.schoolAddress2 @school_address2
          bi.schoolCity @school_city
          bi.schoolState @school_state
          bi.schoolPostalCode @school_postal_code
          bi.schoolCountry @school_country
          bi.major @major
          bi.springBreak @spring_break
          bi.summerBreak @summer_break
          bi.graduationDate @graduation_date
          bi.extracurricularActivities @extracurricular_activities
          bi.career @career
          bi.maritalStatus @marital_status
          bi.baseSalary @base_salary
          bi.agencyFee @agency_fee
          bi.specialTerms @special_terms
          bi.arrestRecord @arrest_record
          bi.duiRecord @dui_record
          bi.childAbuseRecord @child_abuse_record
          bi.smoking @smoking
          bi.smallCraftAbility @small_craft_ability
          bi.cprExpiration @cpr_expiration
          bi.firstAidExpiration @first_aid_expiration
          bi.lifeguardExpiration @lifeguard_expiration
          bi.wsiExpiration @wsi_expiration
          bi.height @height
          bi.weight @weight
          bi.wildernessEMTExpiration @wilderness_emt_expiration
          bi.ropesExpiration @ropes_expiration
          bi.canoeingExpiration @canoeing_expiration
          bi.sailingExpiration @sailing_expiration
          bi.militaryExperience @military_experience
          bi.foreignLanguages @foreign_languages
          bi.musicalInstruments @musical_instruments
        end
      end
    end
  end
end
