# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Controller used to manage fleet upload by CSV file
  #
  class UploadsController < ApplicationController
    include CheckPermissions
    include ChargeabilityCalculator

    before_action -> { check_permissions(allow_manage_vehicles?) }
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
      file_name = VehiclesManagement::UploadFile.call(file: params[:file], user: current_user)
      register_job(file_name)
      redirect_to processing_uploads_path
    end

    ##
    # Renders processing page. Checks if job_id and job_correlation_id are present in redis
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
      return redirect_to uploads_path unless job_id && job_correlation_id

      job = FleetsApi.job_status(job_id: job_id, correlation_id: job_correlation_id)
      react_to_status(job)
    end

    ##
    # Renders calculating chargeability page
    #
    # ==== Path
    #
    #    :GET /upload/calculating_chargeability
    #
    def calculating_chargeability
      # renders static page
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
        Rails.root.join('public/template.csv'),
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
    # Sets proper data to the redis
    def register_job(filename)
      correlation_id = SecureRandom.uuid
      job_id = FleetsApi.register_job(filename: filename, correlation_id: correlation_id)
      add_data_to_redis(correlation_id, job_id)
    end

    # Handles controller reaction based on the given job status.
    # * 'RUNNING' - renders the page
    # * 'CHARGEABILITY_CALCULATION_IN_PROGRESS' or 'SUCCESS' - redirects to local vehicle exemptions page
    # * 'FAILURE' = renders uploads index with errors
    #
    def react_to_status(job)
      status = job[:status].upcase
      return if status == 'RUNNING'

      if %w[CHARGEABILITY_CALCULATION_IN_PROGRESS SUCCESS].include?(status)
        redirect_to_local_exemptions
      else
        handle_failed_processing(job)
      end
    end

    # Adding `show_continue_button` to the session and redirects to local exemptions page
    def redirect_to_local_exemptions
      session[:show_continue_button] = true
      redirect_to local_exemptions_vehicles_path
    end

    # Handles failed scenario after CSV processing
    def handle_failed_processing(job)
      @job_errors = job[:errors]
      @vehicles_present = !current_user.fleet.empty?
      render :index
    end
  end
end
