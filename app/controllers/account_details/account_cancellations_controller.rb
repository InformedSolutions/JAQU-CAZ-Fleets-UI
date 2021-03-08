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
      @form = AccountDetails::AccountCancellationForm.new
    end

    ##
    # Closes the account by calling AccountDetails::CloseAccount service
    #
    # ==== Path
    #
    #    POST /account_cancellation
    #
    def submit_account_cancellation
      @form = AccountDetails::AccountCancellationForm.new(reason: reason_param)
      if @form.valid?
        AccountDetails::CloseAccount.call(account_id: account_id, reason: reason_param)
        sign_out current_user
        redirect_to account_closed_path
      else
        flash.now[:alert] = @form.first_error_message
        render :account_cancellation
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

    private

    # :reason param fetched from params
    def reason_param
      params[:reason]
    end

    # account_id associated with the current_user
    def account_id
      current_user.account_id
    end
  end
end
