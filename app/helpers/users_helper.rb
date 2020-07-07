# frozen_string_literal: true

##
# Module used for manage users flow
module UsersHelper
  # Checks if current user `user_id` not equals to parameter `user_id`
  def not_own_account?(user_id)
    current_user.user_id != user_id
  end
end
