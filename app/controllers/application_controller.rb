# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # protects applications against CSRF
  protect_from_forgery prepend: true
  # checks if a user is logged in
  before_action :authenticate_user!

  # Verifies if current user is admin, if not redirects to root_path
  def verify_admin
    return if current_user.admin

    Rails.logger.warn "User #{current_user.email} is not an administrator"
    redirect_to root_path
  end
end
