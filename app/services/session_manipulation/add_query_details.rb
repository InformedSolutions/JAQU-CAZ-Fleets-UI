# frozen_string_literal: true

module SessionManipulation
  ##
  # It saves query details for other actions than +Submit+
  #
  class AddQueryDetails < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:payment_query] = {}
      session[:payment_query][:search] = search if search
      save_direction_and_vrn('next') if commit.upcase == 'NEXT'
      save_direction_and_vrn('previous') if commit.upcase == 'PREVIOUS'
    end

    private

    # Extracts commit
    def commit
      params[:commit]
    end

    # Extracts search value
    def search
      params.dig(:payment, :vrn_search)
    end

    # Saves direction and vrn
    def save_direction_and_vrn(direction)
      session[:payment_query][:direction] = direction
      session[:payment_query][:vrn] = params.dig(:payment, "#{direction}_vrn")
    end
  end
end
