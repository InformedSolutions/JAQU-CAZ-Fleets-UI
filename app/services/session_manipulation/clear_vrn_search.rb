# frozen_string_literal: true

module SessionManipulation
  ##
  # It clears search variable form payment query session
  #
  class ClearVrnSearch < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      session[:payment_query] ||= {}
      session[:payment_query][:search] = nil
    end
  end
end
