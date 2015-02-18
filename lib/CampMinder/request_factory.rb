module CampMinder::RequestFactory
  include Virtus.model

  attribute :payload, String
  attribute :signed_object, String

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
    request.set_form_data("fn" => fn, "businessPartnerID" => CampMinder::BUSINESS_PARTNER_ID, "signedObject" => signed_object)
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

  def fn
    raise NotImplementedError
  end
end
