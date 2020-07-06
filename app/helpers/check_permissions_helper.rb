# frozen_string_literal: true

# Module used to check user permissions in views
module CheckPermissionsHelper
  include CheckPermissions

  # Checks if permission is checked in the session
  def checked_permission?(permission)
    new_user_permission = session.dig(:new_user, 'permissions')
    return if new_user_permission.nil?

    new_user_permission.include?(permission)
  end
end
