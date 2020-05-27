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
    return redirect_to uploads_path unless job_data

    job = FleetsApi.job_status(
      job_name: job_data[:job_name],
      correlation_id: job_data[:correlation_id]
    )
    react_to_status(job)
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

  # Handles controller reaction based on the given job status.
  # * 'RUNNING' - renders the page
  # * 'SUCCESS' - redirects to fleets index view
  # * 'FAILURE' = renders uploads index with errors
  #
  def react_to_status(job)
    status = job[:status].upcase
    return if status == 'RUNNING'

    session[:job] = nil
    if status == 'SUCCESS'
      handle_successful_processing
    else
      handle_failed_processing(job)
    end
  end

  # Handles successful scenario after CSV processing
  def handle_successful_processing
    vrns_count = current_user.fleet.total_vehicles_count
    flash[:success] = I18n.t('vrn_form.messages.multiple_vrns_added', vrns_count: vrns_count)
    session[:fleet_csv_uploading_process] = true
    redirect_to local_exemptions_vehicles_path
  end

  # Handles failed scenario after CSV processing
  def handle_failed_processing(job)
    @job_errors = job[:errors]
    @vehicles_present = !current_user.fleet.empty?
    render :index
  end

  # Returns hash with the job data
  def job_data
    @job_data ||= session[:job]&.symbolize_keys
  end
end
