# frozen_string_literal: true

##
# Module used to enqueueing messages on AWS SQS to be later caught by Notification Gateway microservice.
#
module Sqs
  ##
  # Base class for the SQS services
  #
  class Base < BaseService
    ##
    # Initializer method. Used by class level +:call+ method
    #
    # ==== Attributes
    #
    # * +email+ - a user's email
    # * +template_id+ - the ID of the GOV.UK Notify template
    #
    def initialize(email:, template_id:)
      @template_id = template_id
      @email = email
    end

    ##
    # Performs a call to SQS.
    #
    # Returns assigned message ID (UUID) if the call was successful.
    #
    # If the call fails, returns false.
    #
    # ==== Exceptions
    #
    # All Aws::SQS::Errors are escaped and service will return false.
    #
    def call
      log_action("Sending SQS message with attributes: #{attributes}")
      id = send_message.message_id
      log_action("SQS message with id: #{id} nad reference: #{reference} was sent")
      id
    rescue Aws::SQS::Errors::ServiceError => e
      log_error(e)
      false
    end

    private

    # Private variables set by the initializer
    attr_reader :email, :template_id

    # Assigns attributes and performs the SQS call.
    # Returns SQS message struct or raises a SQS exception.
    def send_message
      AWS_SQS.send_message(
        queue_url: ENV.fetch('NOTIFY_QUEUE_URL', ''),
        message_group_id: SecureRandom.uuid,
        message_body: attributes,
        message_attributes: {
          'contentType' => { string_value: 'application/json', data_type: 'String' }
        }
      )
    end

    # Serializes message body attributes.
    # Returns a JSON string.
    def attributes
      {
        'templateId' => template_id,
        'emailAddress' => email,
        'personalisation' => personalisation,
        'reference' => reference
      }.to_json
    end

    # Creates an email reference containing the user's email and a timestamp
    # Return string, eg. "test@example.com-131500"
    def reference
      "#{email}-#{Time.current.strftime('%H%M%S')}"
    end
  end
end
