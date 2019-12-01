# frozen_string_literal: true

class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    # renders static page
  end

  def create
    # Storing the password?
    redirect_to root_path
  end
end
