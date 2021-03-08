# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to manage account cancellation
  #
  class AccountCancellationsController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner) }, except: :account_closed
    skip_before_action :authenticate_user!, only: :account_closed

    ##
    # Renders the account cancellation form for the primary user.
    #
    # ==== Path
    #
    #    GET /account_cancellation
    #
    def account_cancellation
      # Renders static page
    end

    ##
    # Closes the account by calling AccountDetails::CloseAccount service
    #
    # ==== Path
    #
    #    POST /submit_cancellation
    #
    def submit_account_cancellation
      form = AccountDetails::AccountCancellationForm.new(reason: params[:reason])
      if form.valid?
        AccountDetails::CloseAccount.call(account_id: current_user.account_id, reason: params[:reason])
        sign_out current_user
        redirect_to account_closed_path
      else
        redirect_to account_cancellation_path, alert: confirmation_error(form, :reason)
      end
    end

    ##
    # Renders the page informing about the account closure
    #
    # ==== Path
    #
    #   GET /account_closed
    def account_closed
      # TODO: CAZB-3736
    end
  end
end
