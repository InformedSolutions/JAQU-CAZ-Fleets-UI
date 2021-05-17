# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Class responsible for getting file from the AWS S3 bucket.
  class LoadFile < BaseService
    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +file_url+ - url of the file
    #
    def initialize(file_url:)
      @file_url = file_url
    end

    # Performs an API call with proper parameters
    def call
      s3_object
    end

    private

    attr_reader :file_url

    # Loads file from AWS S3.
    #
    # Returns a boolean.
    def s3_object
      @s3_object ||= AMAZON_S3_CLIENT.bucket(bucket_name).object(file_url).get
    rescue Aws::S3::Errors::NoSuchKey
      # return nil if file not found.
      nil
    end

    # AWS S3 Bucket Name.
    #
    # Returns a string.
    def bucket_name
      ENV.fetch('S3_CSV_EXPORT_BUCKET', 'bucket_name')
    end
  end
end
