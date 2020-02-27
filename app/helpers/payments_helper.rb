# frozen_string_literal: true

module PaymentsHelper
  # Gets data about the new payment from the session
  def new_payment_data
    (session[:new_payment] || {}).symbolize_keys
  end

  # Checks if given date is checked for the given VRN
  def checked?(vrn, date)
    date.in?(new_payment_data.dig(:details, vrn) || [])
  end

  # Checks if given date is already paid
  def paid?(vehicle, date)
    vehicle.paid_dates.include?(date)
  end
end
