# frozen_string_literal: true

module MockUsers
  def mock_users
    allow(AccountsApi).to receive(:users).and_return(users_api_response)
  end

  def mock_empty_users_list
    allow(AccountsApi).to receive(:users).and_return([])
  end

  def mock_more_then_ten_users
    api_response = users_api_response
    api_response << users_api_response.first
    allow(AccountsApi).to receive(:users).and_return(api_response)
  end

  def mock_user_on_list
    user = new_user
    api_response = {
      accountUserId: user.user_id,
      name: 'Mary Smith',
      email: 'user@example.com'
    }.stringify_keys
    allow(AccountsApi).to receive(:users).and_return([api_response])
    allow_any_instance_of(User).to receive(:authentication).and_return(user)
    fill_sign_in_form
  end

  def mock_user_details
    allow(AccountsApi).to receive(:user).and_return(read_response('users_management/user.json'))
  end

  def mock_update_user
    allow(AccountsApi).to receive(:update_user).and_return({})
  end

  def mock_delete_user
    allow(AccountsApi).to receive(:delete_user).and_return({})
  end

  def uuid
    '5cd7441d-766f-48ff-b8ad-1809586fea37'
  end

  private

  def users_api_response
    read_response('users_management/users.json')['users']
  end
end

World(MockUsers)
