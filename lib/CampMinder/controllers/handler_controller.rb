module CampMinder::HandlerController
  def create
    case params[:fn]
    when 'ClientLinkRequest'
      client_link_request
    when 'ServerTimeGet'
      server_time_get
    end
  end

  private

  def client_link_request
    @client_link_request = CampMinder::ClientLinkRequest.new(params)

    success = @client_link_request.valid_expiration_time?
    reason = @client_link_request.invalid_reason

    redirect_to "#{CampMinder::REDIRECTION_URL}?bpid=#{CampMinder::BUSINESS_PARTNER_ID}&success=#{success}&reason=#{reason}", status: 304
  end

  def server_time_get
    render xml: CampMinder::ServerTimeGet.new, root: 'responseObject'
  end
end