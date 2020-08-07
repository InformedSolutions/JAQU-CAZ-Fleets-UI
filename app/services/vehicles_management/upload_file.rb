# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Service used to upload fleet files to S3
  #
  class UploadFile < BaseService
    ##
    # Initializer method.
    #
    # ==== Params
    #
    # * +file+ - uploaded file
    # * +user+ - an instance of the User class
    #
    def initialize(file:, user:)
      @file = file
      @user = user
      @file_name = "fleet_#{user.user_id}_#{Time.current.to_i}"
      @error = nil
    end

    # The caller method for the service. It invokes validating and uploading file to AWS S3
    #
    # Returns a boolean
    def call
      validate
      upload_to_s3
      file_name
    end

    private

    # Validates a csv file.
    #
    # Raises exception if at least one validation not returns true.
    #
    # Returns a boolean.
    def validate
      raise CsvUploadException, error if no_file_selected? || invalid_extname? || filesize_too_big?
    end

    # Checks if file is present.
    # If not, add error message to +error+.
    #
    # Returns a boolean if file is present.
    # Returns a string if not.
    def no_file_selected?
      @error = I18n.t('csv.errors.no_file') if file.nil?
    end

    # Checks if filename extension equals `csv`.
    # If not, add error message to +error+.
    #
    # Returns a boolean if filename extension equals `csv`.
    # Returns a string if not.
    def invalid_extname?
      return if File.extname(file.original_filename).downcase == '.csv'

      @error = I18n.t('csv.errors.invalid_ext')
    end

    # Checks if file size not bigger than `Rails.configuration.x.csv_file_size_limit`
    # Returns a boolean if filename is compliant with the naming rules
    # Returns a string if not.
    def filesize_too_big?
      csv_file_size_limit = Rails.configuration.x.csv_file_size_limit
      @error = "The CSV must be smaller than #{csv_file_size_limit}MB" if file.size > csv_file_size_limit.megabytes
    end

    # Uploading file to AWS S3.
    #
    # Raise exception if upload failed
    #
    # Returns a boolean.
    def upload_to_s3
      log_action 'Uploading file to S3'
      return true if aws_call

      raise CsvUploadException, I18n.t('csv.errors.base')
    rescue Aws::S3::Errors::ServiceError => e
      log_error e
      raise CsvUploadException, I18n.t('csv.errors.base')
    end

    # Uploading file to AWS S3.
    #
    # Returns a boolean.
    def aws_call
      s3_object = AMAZON_S3_CLIENT.bucket(bucket_name).object(file_name)
      s3_object.upload_file(file, metadata: metadata)
    end

    # AWS S3 Bucket Name.
    #
    # Returns a string.
    def bucket_name
      ENV.fetch('S3_AWS_BUCKET', 'bucket_name')
    end

    def metadata
      {
        'account-user-id': user.user_id,
        'account-id': user.account_id
      }
    end

    # Attributes used internally to save values.
    attr_reader :file, :error, :user, :file_name
  end
end
