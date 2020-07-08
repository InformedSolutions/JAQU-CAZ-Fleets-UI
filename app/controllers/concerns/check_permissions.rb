# frozen_string_literal: true

# Module used to check user permissions in controllers
module CheckPermissions
  extend ActiveSupport::Concern

  # Checks if user has a proper permissions
  # If not redirects to the not found page
  def check_permissions(value)
    return if value == true

    Rails.logger.warn('Access Denied. Redirects to :not_found page')
    redirect_to not_found_path
  end

  # Checks if user has a +MANAGE_USERS+ permission
  def allow_manage_users?
    current_user.permissions&.include?('MANAGE_USERS')
  end

  # Checks if user has a +MANAGE_VEHICLES+ permission
  def allow_manage_vehicles?
    current_user.permissions&.include?('MANAGE_VEHICLES')
  end

  # Checks if user has a +MANAGE_MANDATES+ permission
  def allow_manage_mandates?
    current_user.permissions&.include?('MANAGE_MANDATES')
  end

  # Checks if user has a +MAKE_PAYMENTS+ permission
  def allow_make_payments?
    current_user.permissions&.include?('MAKE_PAYMENTS')
  end
end