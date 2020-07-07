# frozen_string_literal: true

##
# Module used for manage users flow
module UsersHelper
  # Checks if current user `user_id` not equals to parameter `account_id`
  def not_own_account?(account_id)
    current_user.user_id != account_id
  end
end
