# frozen_string_literal: true

module SessionManipulation
  class AddPaymentDetails < BaseManipulator
    def call
      session[:new_payment] ||= {}
      session[:new_payment][:details] ||= {}
      new_data = params.dig(:payment, :vehicles)
      session[:new_payment][:details].merge!(new_data) if new_data
    end
  end
end
