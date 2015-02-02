class CampMinder::StaffHire
  include Virtus.model

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
  attribute :agency_member_number, String
  attribute :hire_date, String
  attribute :employment_start_date, String
  attribute :employment_end_date, String
  attribute :marital_status, String
  attribute :stipend, String
  attribute :agency_fee, String
  attribute :smoking, String
  attribute :foreign_languages, String

  def initialize(args)
    super(args)
  end
end
