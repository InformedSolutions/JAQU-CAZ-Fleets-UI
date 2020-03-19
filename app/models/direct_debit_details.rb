# frozen_string_literal: true

##
# Class used to serialize data from PUT /payments/:id backend API endpoint.
# Calls PaymentsApi.payment_status
#
class DirectDebitDetails
  def initialize(data)
    @data = data
  end

  # Returns the payment status.
  #
  # Eg. 'SUCCESS'
  def status
    data['status']&.upcase
  end

  # Returns an email that was submitted by the user during the payment process.
  def user_email
    data['userEmail']
  end

  # Returns the central reference number of the payment.
  def payment_reference
    data['referenceNumber']
  end

  # Returns the external payment ID.
  def external_id
    data['externalPaymentId']
  end

  private

  # Reader for data hash
  attr_reader :data
end
