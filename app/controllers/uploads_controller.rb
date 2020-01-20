# frozen_string_literal: true

##
# Controller used to manage fleet upload by CSV file
#
class UploadsController < ApplicationController
  ##
  # Renders the view with the file input
  #
  # ==== Path
  #
  #     GET /uploads
  #
  def index
    @vehicles_present = current_user.vehicles.any?
  end

  ##
  # Validates and uploads the submitted file to S3
  #
  # ==== Path
  #
  #     POST /uploads
  #
  # ==== Params
  #
  # * +file+ - the submitted file
  #
  def create
    session[:file_name] = UploadFile.call(file: params[:file], user: current_user)
    redirect_to processing_uploads_path
  rescue CsvUploadException => e
    redirect_to uploads_path, alert: e.message
  end

  ##
  # Renders processing page. Checks if file_name is present
  #
  # ==== Path
  #
  #     GET /uploads/processing
  #
  # ==== Params
  #
  # * +file_name+ - The name of the submitted file, required in the session
  #
  def processing
    redirect_to uploads_path unless session[:file_name]
  end

  # Mocks successful upload - add vehicles to fleet and redirects to :index
  def mock_successful_upload
    session[:file_name] = nil
    FleetsApi.mock_upload_fleet
    redirect_to fleets_path
  end

  ## Mocks failed upload - sets errors and renders :index
  def mock_failed_upload
    session[:file_name] = nil
    @job_errors = ['Invalid VRN in line 3', 'Invalid VRN in line 5']
    @vehicles_present = current_user.vehicles.any?
    render :index
  end
end
