# frozen_string_literal: true

module MockUsers
  def mock_users
    api_response = read_response('/manage_users/users.json')['users']
    allow(AccountsApi).to receive(:users).and_return(api_response)
  end
end

World(MockUsers)
