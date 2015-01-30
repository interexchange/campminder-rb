class CampMinder::ServerTimeGet
  include Virtus.model

  attribute :status, String, default: "True"
  attribute :details, String, default: "ServerTimeGet"
  attribute :data, String

  def initialize
    super
    @data = Time.now.utc.iso8601.to_s
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    builder = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    builder.instruct! unless options[:skip_instruct]
    builder.responseObject(version: "1") do |b|
      b.status @status
      b.details @details
      b.data @data
    end
  end
end
