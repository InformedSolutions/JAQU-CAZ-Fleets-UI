# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    # renders static page
  end

  def create
    redirect_to user_added_path
  end

  def show
    # renders static page
  end

  def update
    # renders static page
  end

  def destroy
    # renders static page
  end

  def another_user
    return redirect_to add_users_path if params['add-user'] == 'yes'

    redirect_to account_set_up_path
  end

  ##
  # Renders the manager users page.
  #
  # ==== Path
  #
  #    GET /fleets/organisation-account/manage-users
  #
  def manage
    # renders static page
  end

  ##
  # Renders the upload fleet page.
  #
  # ==== Path
  #
  #    GET /fleets/single-user/csv-upload
  #
  def upload
    # renders static page
  end

  ##
  # Renders the payment page.
  #
  # ==== Path
  #
  #    GET /fleets/single-user/first-upload
  #
  def payment
    # renders static page
  end

  ##
  # Renders the direct debit mandate page.
  #
  # ==== Path
  #
  #    GET /fleets/single-user/select-direct-debit
  #
  def caz_selection
    # renders static page
  end
end
