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
    to_xml(skip_instruct: true)
  end

  def post
    true
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    builder = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    builder.instruct! unless options[:skip_instruct]
    builder.staffDataContainer(version: "1") do |b|
      b.cmClientId @client_id
      b.token @token
      b.partnerClientId @partner_client_id
      b.staffDataArray do |b|
        b.staffData(version: "1") do |b|
          b.uniqueKey @unique_key
          b.firstName @first_name
          b.lastName @last_name
          b.gender @gender
          b.dob @dob
          b.birthPlace @birth_place
          b.citizenship @citizenship
          b.address1 @address1
          b.city @city
          b.isStateProvinceRequired @state_province.present?
          b.stateProvince @state_province
          b.isPostalCodeRequired @postal_code.present?
          b.postalCode @postal_code
          b.country @country
          b.email @email
          b.agencyMemberNumber @agency_member_number
          b.address2 @address2
          b.middleInitial @middle_initial
          b.nickName @nick_name
          b.nationalID @national_id
          b.licenseState @license_state
          b.licenseNumber @license_number
          b.permanentPhone @permanent_phone
          b.schoolPhone @school_phone
          b.cellPhone @cell_phone
          b.workPhone @work_phone
          b.otherPhone @other_phone
          b.email2 @email2
          b.hireDate @hire_date
          b.occupationYearAtSchool @occupation_year_at_school
          b.employmentStartDate @employment_start_date
          b.employmentEndDate @employment_end_date
          b.school @school
          b.schoolAddress1 @school_address1
          b.schoolAddress2 @school_address2
          b.schoolCity @school_city
          b.schoolState @school_state
          b.schoolPostalCode @school_postal_code
          b.schoolCountry @school_country
          b.major @major
          b.springBreak @spring_break
          b.summerBreak @summer_break
          b.graduationDate @graduation_date
          b.extracurricularActivities @extracurricular_activities
          b.career @career
          b.maritalStatus @marital_status
          b.baseSalary @base_salary
          b.agencyFee @agency_fee
          b.specialTerms @special_terms
          b.arrestRecord @arrest_record
          b.duiRecord @dui_record
          b.childAbuseRecord @child_abuse_record
          b.smoking @smoking
          b.smallCraftAbility @small_craft_ability
          b.cprExpiration @cpr_expiration
          b.firstAidExpiration @first_aid_expiration
          b.lifeguardExpiration @lifeguard_expiration
          b.wsiExpiration @wsi_expiration
          b.height @height
          b.weight @weight
          b.wildernessEMTExpiration @wilderness_emt_expiration
          b.ropesExpiration @ropes_expiration
          b.canoeingExpiration @canoeing_expiration
          b.sailingExpiration @sailing_expiration
          b.militaryExperience @military_experience
          b.foreignLanguages @foreign_languages
          b.musicalInstruments @musical_instruments
        end
      end
    end
  end
end
