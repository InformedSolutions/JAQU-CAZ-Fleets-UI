# frozen_string_literal: true

module PaymentsHelper
  # Gets data about the new payment from the session
  def new_payment_data
    (session[:new_payment] || {}).symbolize_keys
  end
end
