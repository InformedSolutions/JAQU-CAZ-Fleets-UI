# frozen_string_literal: true

##
# Controller used to check which service is relevant for the user.
#
class RelevantServiceController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_password_age

  ##
  # Renders the form to check the relevant service for the user
  #
  # ==== Path
  #    GET /what_would_you_like_to_do
  #
  def what_would_you_like_to_do
    # renders form
  end

  ##
  # Check provided answer and redirect too relevant service.
  #
  # ==== Path
  #    POST /what_would_you_like_to_do
  #
  def submit_what_would_you_like_to_do
    form = RelevantServiceForm.new(params[:check_vehicle_option])
    if form.valid?
      redirect_to determine_relevant_service_path(params[:check_vehicle_option])
    else
      flash.now.alert = form.first_error_message
      render :what_would_you_like_to_do
    end
  end

  private

  # chooses rlevant service url based on the provided option choosen by user.
  def determine_relevant_service_path(check_vehicle_option)
    if check_vehicle_option == 'single'
      "#{Rails.configuration.x.check_air_standard_url}vehicle_checkers/enter_details"
    else
      root_path
    end
  end
end
