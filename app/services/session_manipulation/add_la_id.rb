# frozen_string_literal: true

##
# Module used to improve session management during the payment process
#
module SessionManipulation
  ##
  # Save selected LA ID.
  # It doesn't overrides data for the same LA.
  #
  class AddLaId < BaseManipulator
    ##
    # Instance level +call+ method
    #
    def call
      la_id = params['local-authority']
      session.delete(:payment_query)
      return if new_payment_data[:la_id] == la_id

      session[:new_payment] = { la_id: la_id }
    end
  end
end
