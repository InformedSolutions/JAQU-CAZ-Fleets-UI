# frozen_string_literal: true

class UsersController < ApplicationController
  # Verifies if current user is admin
  before_action :verify_admin
  ##
  # Renders add users page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/add-users
  #
  def new
    # renders static page
  end

  ##
  # Validates submitted name and email_address.
  # If successful, redirects to {manage}[rdoc-ref:UsersController.manage]
  # If no, renders {new} [rdoc-ref:UsersController.new]
  #
  # ==== Path
  #
  #    POST /fleets/organisation-account/add-users
  #
  def create
    form = NewUserForm.new(users_params)
    if form.valid?
      # TO DO: Send email invite
      redirect_to manage_users_path
    else
      @errors = form.errors.messages
      render :new
    end
  end

  def delete
    # renders static page
  end

  def destroy
    # renders static page
  end

  ##
  # Renders the manager users page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/manage-users
  #
  def manage
    @users = [
      { name: 'First Fake User', email: 'example@email.com' },
      { name: 'Second Fake User', email: 'example2@email.com' }
    ]
  end

  ##
  # Verifies if user confirms to create a new fleet administrator
  # If yes, redirects to {adding a new user page}[rdoc-ref:UsersController.new]
  # If no, redirects to {dashboard page}[rdoc-ref:DashboardController.index]
  # If form was not confirmed, redirects to {manage}[rdoc-ref:UsersController.manage]
  #
  # ==== Path
  #
  #    POST /fleets/organisation-account/manage-users
  #
  def confirm_manage
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      return redirect_to manage_users_path, alert: form.errors.messages[:confirmation].first
    end

    redirect_to form.confirmed? ? add_users_path : dashboard_path
  end

  ##
  # Renders the upload fleet page.
  #
  # ==== Path
  #
  #    :GET /fleets/single-user/csv-upload
  #
  def upload
    # renders static page
  end

  ##
  # Renders the payment page.
  #
  # ==== Path
  #
  #    :GET /fleets/single-user/first-upload
  #
  def payment
    # renders static page
  end

  ##
  # Renders the direct debit mandate page.
  #
  # ==== Path
  #
  #    :GET /fleets/single-user/select-direct-debit
  #
  def caz_selection
    # renders static page
  end

  private

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-admin-creation']
  end

  # Returns the list of permitted user params
  def users_params
    params.require(:users).permit(:name, :email_address)
  end
end
