# frozen_string_literal: true

module MockUsers
  def mock_users
    api_response = read_response('/manage_users/users.json')['users']
    allow(AccountsApi).to receive(:users).and_return(api_response)
  end

  def mock_empty_users_list
    allow(AccountsApi).to receive(:users).and_return([])
  end

  def mock_more_then_ten_users
    api_response = read_response('/manage_users/users.json')['users']
    api_response << api_response.first
    allow(AccountsApi).to receive(:users).and_return(api_response)
  end

  def mock_user_on_list
    user = new_user
    api_response = {
      accountUserId: user.account_id,
      name: 'Mary Smith',
      email: 'user@example.com'
    }.stringify_keys
    allow(AccountsApi).to receive(:users).and_return([api_response])
    allow_any_instance_of(User).to receive(:authentication).and_return(user)
    fill_sign_in_form
  end
end

World(MockUsers)
