# frozen_string_literal: true

module SessionManipulation
  class AddQueryDetails < BaseManipulator
    def call
      session[:payment_query] = {}
      session[:payment_query][:search] = search if search
      save_direction_and_vrn('next') if commit == 'Next'
      save_direction_and_vrn('previous') if commit == 'Previous'
    end

    private

    def commit
      params[:commit]
    end

    def search
      params.dig(:payment, :vrn_search)
    end

    def save_direction_and_vrn(direction)
      session[:payment_query][:direction] = direction
      session[:payment_query][:vrn] = params.dig(:payment, "#{direction}_vrn")
    end
  end
end
