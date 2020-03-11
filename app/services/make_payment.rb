# frozen_string_literal: true

##
# Service used to prepare parameters and make a call to service responsible
# for payment creation.
#
class MakePayment < BaseService
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +payment_data+ - hash, data coming from session storing CAZ id
  #                    and payments information
  # * +user_id+ - ID of the user who pays.
  #
  def initialize(payment_data:, user_id:)
    @payment_data = payment_data
    @user_id = user_id
  end

  ##
  # The caller method for the service.
  # Method calls +PaymentsApi.create_payment+ method which performs an actual
  # request to Payments API.
  #
  def call
    response = PaymentsApi.create_payment(
      caz_id: caz_id,
      return_url: return_url,
      user_id: user_id,
      transactions: transformed_transactions
    )

    response['nextUrl']
  end

  private

  attr_reader :payment_data, :user_id

  ##
  # Method fetches +caz_id+ from provided +payment_data+.
  #
  def caz_id
    payment_data[:la_id]
  end

  ##
  # Method that returns URL to which user will be redirected
  # after performing the payment
  #
  def return_url
    # TODO: Update in CAZ-2043
    'http://example.com'
  end

  ##
  # Method transforms data stored in provided hash a format expected by
  # the API spec. Returns information only about days which are going to
  # be paid.
  #
  def transformed_transactions
    payment_data[:details]
      .select { |_, payment_detail| payment_detail.symbolize_keys![:dates].any? }
      .map { |_, payment_detail| extract_data_for_each_date(payment_detail) }
      .flatten
  end

  ##
  # Method which transforms data to have a single object for each date.
  #
  def extract_data_for_each_date(payment_detail)
    payment_detail[:dates].map do |date|
      {
        vrn: payment_detail[:vrn],
        charge: charge_in_pence(payment_detail[:charge]),
        travel_date: date,
        tariff_code: payment_detail[:tariff]
      }
    end
  end

  # convert charge in pence
  def charge_in_pence(charge_in_pounds)
    (charge_in_pounds.to_f * 100).to_i
  end
end
