# frozen_string_literal: true

##
# Controller used to manage Direct Debits
#
class DebitsController < ApplicationController
  before_action :assign_debit

  ##
  # Renders the dashboard page.
  # Redirect to #new if there is no mandate assigned to the account.
  #
  # ==== Path
  #
  #    GET /debits
  #
  def index
    @mandates = @debit.mandates
    return redirect_to new_debit_path if @mandates.size.zero?

    @zones = @debit.zones_without_mandate
  end

  ##
  # Renders a selector to add a new mandate.
  # If there is no possible new mandates, redirects to #index
  #
  # ==== Path
  #
  #    GET /debits/new
  #
  def new
    @zones = @debit.zones_without_mandate
    return redirect_to debits_path if @zones.size.zero?

    @mandates = @debit.mandates
  end

  ##
  # Validates and creates a new mandate.
  #
  # ==== Path
  #
  #    POST /debits
  #
  def create
    form = LocalAuthorityForm.new(authority: params['local-authority'])
    unless form.valid?
      return redirect_to new_debit_path, alert: confirmation_error(form, :authority)
    end

    @debit.add_mandate(form.authority)
    redirect_to debits_path
  end

  private

  def assign_debit
    @debit = current_user.direct_debit
  end
end
