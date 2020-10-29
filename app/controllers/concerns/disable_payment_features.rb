# frozen_string_literal: true

# Used for toggle content for `A-Day`, should be remove once it is no longer needed
module DisablePaymentFeatures
  # Assign +bath_live+ variable
  def assign_bath_live
    @bath_live = bath_live?
  end

  # def disable_payment_features?
  #   return if current_user.beta_tester
  #
  #   bath_live?
  # end

  private

  # Checks if the current date is after the Bath payments has gone live
  def bath_live?
    CleanAirZone.all.find { |caz| caz.name == 'Bath' }.active_charge_start_date.past?
  end
end
