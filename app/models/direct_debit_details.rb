# frozen_string_literal: true

##
# Class used to serialize data from DebitsApi.caz_mandates
# Calls PaymentsApi.payment_status
#
class DirectDebitDetails
  def initialize(data)
    @data = data
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
