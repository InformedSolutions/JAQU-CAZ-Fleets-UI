# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Class responsible for parsing file name from url
  class ParseFileName < BaseService
    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +file_url+ - an url for downloading payment history from AWS S3.
    #
    def initialize(file_url:)
      @file_url = file_url
    end

    # Parse file name
    def call
      parsed_file_name
    end

    private

    # Parsed file name from url, e.g. '25March2021-150501.csv'
    def parsed_file_name
      File.basename(URI.parse(@file_url).path)
    rescue URI::InvalidURIError
      nil
    end
  end
end
