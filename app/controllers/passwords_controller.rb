# frozen_string_literal: true

class PasswordsController < ApplicationController
  def new; end

  def create
    # Storing the password?
    redirect_to add_users_path
  end
end
