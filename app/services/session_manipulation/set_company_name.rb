# frozen_string_literal: true

##
# Module used to improve session management during the payment process
#
module SessionManipulation
  ##
  # Service used to set payment ID returned by the Payments API.
  #
  class SetCompanyName < BaseManipulator
    # Adds the +company_name+ to the session. Used by the class level method +.call+
    def call
      session[:new_account] ||= {}
      session[:new_account][:company_name] = params[:company_name]
    end
  end
end
