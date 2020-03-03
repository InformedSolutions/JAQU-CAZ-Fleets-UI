# frozen_string_literal: true

module SessionManipulation
  ##
  # Saves submitted vehicles details.
  # It doesn't override details for vehicles from different pages.
  #
  class AddPaymentDetails < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:new_payment] ||= {}
      session[:new_payment][:details] ||= {}
      new_data = params.dig(:payment, :vehicles)
      session[:new_payment][:details].merge!(new_data) if new_data
    end
  end
end
