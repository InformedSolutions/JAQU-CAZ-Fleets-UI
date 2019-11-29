# frozen_string_literal: true

class UsersController < ApplicationController
  def new; end

  def create
    redirect_to user_added_path
  end

  def show; end

  def update; end

  def destroy; end

  def another_user
    return redirect_to add_users_path if params['add-user'] == 'yes'

    redirect_to account_set_up_path
  end
end
