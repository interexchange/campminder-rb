module CampMinder::StaffHireController
  def create
    @camp_minder_staff_hire = CampMinder::StaffHire.new(params)

    if @camp_minder_staff_hire.post && store_staff_hire
      render status: 200, json: success_response
    else
      render status: 400, json: failure_response
    end
  end

  private

  def store_staff_hire
    raise NotImplementedError
  end

  def success_response
    {
      type: "success",
      message: "Staff Hire successfully added to CampMinder"
    }
  end

  def failure_response
    {
      type: "failure",
      message: "Staff Hire could not be completed with CampMinder"
    }
  end
end
