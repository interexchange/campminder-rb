class CampMinder::EstablishConnection
  attribute :client_id, String
  attribute :person_id, String
  attribute :token, String
  attribute :partner_client_id, String

  attribute :failure_details, String

  def initialize(data)
    @client_id = data.fetch("client_id")
    @person_id = data.fetch("person_id")
    @token = data.fetch("token")
    @partner_client_id = data.fetch("partner_client_id")
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    builder = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    builder.instruct! unless options[:skip_instruct]
    builder.connectionRequest(version: "1") do |b|
      b.clientID @client_id
      b.personID @person_id
      b.token @token
      b.partnerClientID @partner_client_id
    end
  end

  def fn
    "EstablishConnection"
  end
end
