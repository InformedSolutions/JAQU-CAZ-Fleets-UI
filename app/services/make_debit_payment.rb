# frozen_string_literal: true

##
# Service used to prepare parameters and make a call to service responsible
# for direct debit payment creation.
#
class MakeDebitPayment < BasePayment
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +payment_data+ - hash, data coming from session storing CAZ id and payments information
  # * +user_id+ - ID of the user who pays
  # * +mandate_id+ - ID of the mandate
  #
  def initialize(payment_data:, user_id:, mandate_id:)
    @payment_data = payment_data
    @user_id = user_id
    @mandate_id = mandate_id
  end

  ##
  # The caller method for the service.
  # Method calls +DebitsApi.create_payment+ method which performs an actual
  # request to Payments API.
  #
  def call
    DebitsApi.create_payment(
      caz_id: caz_id,
      user_id: user_id,
      mandate_id: mandate_id,
      transactions: transformed_transactions
    )
  end

  private

  attr_reader :mandate_id
end
