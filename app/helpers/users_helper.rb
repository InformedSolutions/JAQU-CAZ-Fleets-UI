# frozen_string_literal: true

##
# Module used for manage users flow
module UsersHelper
  # Checks if user dont want to edit or remove his own account
  # If yes redirects to the Manage users page
  def check_account_ownership?(user_id)
    return if current_user.user_id != user_id

    Rails.logger.warn('User want to edit or remove his own account. Redirects to Manage users page')
    redirect_to users_path
  end
end
