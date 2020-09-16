# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  module MockedResponses
    def mock_users
      api_response = read_response('users_management/users.json')['users']
      allow(AccountsApi).to receive(:users).and_return(api_response)
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
  end
end
