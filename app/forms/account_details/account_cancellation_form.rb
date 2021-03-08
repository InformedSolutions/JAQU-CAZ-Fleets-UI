# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # The form used to validate account cancellation reason
  #
  # ==== Usage
  #   form = AccountDetails::AccountCancellationForm.new(reason: params['reason'])
  #   do_something if form.valid?
  #
  class AccountCancellationForm < BaseForm
    # Accessor for the cancellation reason
    attr_accessor :reason

    # Presence and value validator
    validates :reason, presence: { message: I18n.t('account_cancellation_form.reason_missing') },
                       inclusion: { in: %w[VEHICLES_UPDATED_TO_NON_CHARGEABLE VEHICLES_NOT_CHARGED
                                           NOT_A_TRAVEL_DESTINATION NON_OPERATIONAL_BUSINESS OTHER] }
  end
end
