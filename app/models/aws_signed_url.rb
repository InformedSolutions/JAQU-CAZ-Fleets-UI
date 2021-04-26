# frozen_string_literal: true

##
# Class used to extract information about URL expiration time from AWS signed url.
#
class AwsSignedUrl
  ##
  # Initializer method for the class.
  #
  # ==== Attributes
  #
  # * +url+ - AWS signed url
  #
  def initialize(url)
    @url = url
  end

  # Based on creation_time and expiry_time calculates the date when URL becomes inactive.
  def expires_at
    creation_time + expiry_time.seconds
  end

  private

  attr_reader :url

  # Fetches creation datetime from URL and transforms to Time object.
  def creation_time
    Time.parse(parsed_query_params['X-Amz-Date']).utc
  end

  # Returns an integer which holds information about link activity in seconds e.g. 3600
  def expiry_time
    parsed_query_params['X-Amz-Expires'].to_i
  end

  # Parses received URL
  def parsed_url
    @parsed_url ||= CGI.parse(URI.parse(url).query)
  end

  # Transforms received parameters from URL to a hash object
  def parsed_query_params
    @parsed_query_params ||= parsed_url.transform_values(&:first)
  end
end
