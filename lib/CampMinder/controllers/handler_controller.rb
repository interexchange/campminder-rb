module CampMinder::HandlerController
  def create
    case params[:fn]
    when "ClientLinkRequest"
      client_link_request
    when "ServerTimeGet"
      server_time_get
    end
  end

  private

  def client_link_request
    @client_link_request = CampMinder::ClientLinkRequest.new(params)

    success = @client_link_request.valid_expiration_time?
    reason = @client_link_request.invalid_reason

    if success
      success = valid_username_password?(@client_link_request.username, @client_link_request.password)
      reason = "invalid username and password" unless success
    end

    if success
      if partner_client_id != nil
        connection = CampMinder::EstablishConnection.new(
          "client_id" => @client_link_request.client_id,
          "person_id" => @client_link_request.person_id,
          "token" => @client_link_request.token,
          "partner_client_id" => partner_client_id
        )

        if !connection.post
          success = false
          reason = connection.failure_details
        end
      else
        success = false
        reason = "partner client id not found"
      end
    end

    if success
      success = store_partner_client(
        partner_client_id,
        @client_link_request.client_id,
        @client_link_request.person_id,
        @client_link_request.token,
        true
      )
      reason = "failed to save partner client" unless success
    end

    campminder_redirect_url = "#{ CampMinder::REDIRECTION_URL }?bpid=#{ CampMinder::BUSINESS_PARTNER_ID }&success=#{ success }&reason=#{ reason }"
    redirect_to(campminder_redirect_url, allow_other_host: true)
  end

  def server_time_get
    render xml: CampMinder::ServerTimeGet.new, skip_instruct: true
  end

  def valid_username_password?(username, password)
    raise NotImplementedError
  end

  def partner_client_id
    raise NotImplementedError
  end

  def store_partner_client(partner_client_id, client_id, person_id, token, connection_status)
    raise NotImplementedError
  end
end
