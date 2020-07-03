# frozen_string_literal: true

# Module used to check user permissions in views
module CheckPermissionsHelper
  include CheckPermissions

  def checked_permission?(permission)
    new_user_permission = session.dig(:new_user, 'permissions')
    return nil unless new_user_permission

    new_user_permission.include?(permission)
  end
end
