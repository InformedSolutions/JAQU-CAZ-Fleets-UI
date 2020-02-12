# frozen_string_literal: true

##
# Controller used to pay for fleet
#
class PaymentsController < ApplicationController
  before_action :assign_fleet
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
    redirect_to first_upload_fleets_path if @fleet.empty?
  end

  private

  # Creates instant variable with fleet object
  def assign_fleet
    @fleet = current_user.fleet
  end
end
