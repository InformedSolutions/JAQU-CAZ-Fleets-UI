# frozen_string_literal: true

##
# Controller used to manage fleet upload by CSV file
#
class UploadsController < ApplicationController
  rescue_from CsvUploadException, with: :render_upload_error

  ##
  # Renders the view with the file input
  #
  # ==== Path
  #
  #     GET /uploads
  #
  def index
    @vehicles_present = !current_user.fleet.empty?
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
    file_name = UploadFile.call(file: params[:file], user: current_user)
    register_job(file_name)
    redirect_to processing_uploads_path
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
  # * +job+ - Hash with upload data, required in the session
  #    * +filename+ - string, the name of the uploaded file
  #    * +job_name+ - string, the job name returned by the backend API
  #    * +correlation_id+ - uuid, ID used to identify calls
  #
  def processing
    redirect_to uploads_path unless session[:job]
  end

  ##
  # Sends CSV template for uploading the fleet
  #
  # ==== Path
  #
  #     GET /uploads/download_template
  #
  def download_template
    send_file(
      "#{Rails.root}/public/template.csv",
      filename: 'VehicleUploadTemplate.csv',
      type: 'text/csv'
    )
  end

  # Mocks successful upload - add vehicles to fleet and redirects to :index
  def mock_successful_upload
    session[:job] = nil
    FleetsApi.mock_upload_fleet
    redirect_to fleets_path
  end

  ## Mocks failed upload - sets errors and renders :index
  def mock_failed_upload
    session[:job] = nil
    @job_errors = ['Invalid VRN in line 3', 'Invalid VRN in line 5']
    @vehicles_present = current_user.vehicles.any?
    render :index
  end

  private

  # Redirects to uploads page and renders alert
  def render_upload_error(exception)
    redirect_to uploads_path, alert: exception.message
  end

  # Register upload job in the backend API.
  # Sets proper data in the session.
  def register_job(filename)
    correlation_id = SecureRandom.uuid
    job_name = FleetsApi.register_job(filename: filename, correlation_id: correlation_id)
    session[:job] = {
      job_name: job_name,
      filename: filename,
      correlation_id: correlation_id
    }
  end
end
