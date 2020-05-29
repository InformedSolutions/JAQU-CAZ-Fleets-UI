# frozen_string_literal: true

##
# Class used to serialize the payment details on the success page
#
# ==== Usage
#
#    @payment_details = PaymentDetails.new(session[:vehicle_details])
#
class PaymentDetails
  attr_reader :entries_paid, :total_charge

  ##
  # Initializer method
  #
  # ==== Params
  # * +session_details+ - hash
  #   * +external_id+ - payment ID in backend DB
  #   * +user_email+ - user email address
  #   * +reference_number+ - payment reference number
  #   * +la_id+ - selected local authority ID
  # * +entries_paid+ - quantity of paid days
  # * +total_charge+ - sum of charges for all entries
  #
  def initialize(session_details:, entries_paid:, total_charge:)
    @session_details = session_details
    @entries_paid = entries_paid
    @total_charge = total_charge
  end

  # Returns selected local authority name, eg. 'Leeds'
  def caz_name
    CleanAirZone.find(session_details[:la_id]).name
  end

  # Returns user email address
  def user_email
    session_details[:user_email]
  end

  # Returns the payment reference number
  def reference
    session_details[:payment_reference]
  end

  # Returns the payment ID in backend DB
  def external_id
    session_details[:external_id]
  end

  private

  # Reader function
  attr_reader :session_details
end
