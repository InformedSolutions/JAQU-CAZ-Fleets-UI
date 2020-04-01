# frozen_string_literal: true

##
# This is an abstract class used as a base for make payments service classes.
#
class BasePayment < BaseService
  private

  # Attributes used internally
  attr_reader :payment_data, :user_id

  ##
  # Method fetches +caz_id+ from provided +payment_data+.
  #
  def caz_id
    payment_data[:la_id]
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
