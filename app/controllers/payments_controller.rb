# frozen_string_literal: true

##
# Controller used to pay for fleet
#
class PaymentsController < ApplicationController
  before_action :assign_fleet
  before_action :check_la, only: :matrix

  ##
  # Renders payment page.
  # If the fleet is empty, redirects to {rdoc-ref:FleetsController.first_upload}
  # [rdoc-ref:FleetsController.first_upload]
  #
  # ==== Path
  #
  #    :GET /payments
  #
  def index
    return redirect_to first_upload_fleets_path if @fleet.empty?

    @zones = CleanAirZone.all
  end

  ##
  # Validates and saves selected local authority.
  #
  # ==== Path
  #
  #    :POST /payments
  #
  def local_authority
    form = LocalAuthorityForm.new(authority: params['local-authority'])
    if form.valid?
      session[:new_payment] = { la_id: form.authority }
      redirect_to matrix_payments_path
    else
      redirect_to payments_path, alert: confirmation_error(form, :authority)
    end
  end

  ##
  # Renders payment matrix page.
  #
  # ==== Path
  #
  #    :GET /payments
  #
  def matrix
    # Renders matrix
  end

  private

  # Creates instant variable with fleet object
  def assign_fleet
    @fleet = current_user.fleet
  end

  # Checks if the user selected LA
  def check_la
    redirect_to payments_path unless helpers.new_payment_data[:la_id]
  end
end
