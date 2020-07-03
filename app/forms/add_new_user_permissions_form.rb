# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/users/new.html.haml+.
class AddNewUserPermissionsForm < NewUserBaseForm
  # validates name attribute to presence
  validates :permissions, presence: { message: I18n.t('add_new_user_form.errors.permissions_missing') }

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +account_id+ - uuid, the id of the administrator user account
  # + +new_user+ - array, user params: email, name and permissions
  #
  def initialize(current_user:, new_user:, verification_url:)
    @account_id = current_user.account_id
    @user_id = current_user.user_id
    @name = new_user['name']
    @email = new_user['email']
    @permissions = new_user['permissions']
    @verification_url = verification_url
  end

  # Submits the form - invite user and clear session from new user data
  def submit
    invite_user_api_call
  end

  private

  attr_reader :session, :permissions, :verification_url, :user_id

  # API request to create user invitation
  def invite_user_api_call
    new_user_data = {
      name: name,
      email: email,
      permissions: permissions,
      verification_url: verification_url
    }
    AccountsApi.user_invitations(account_id: account_id, user_id: user_id, new_user_data: new_user_data)
  end
end
