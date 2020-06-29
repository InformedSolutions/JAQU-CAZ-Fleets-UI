# frozen_string_literal: true

##
# Module used for manage users flow
module ManageUsers
  ##
  # Represents the virtual model of the user, used in +app/views/users/index.html.haml+.
  #
  class User
    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # user name
    def name
      data[:name]
    end

    # user email
    def email
      data[:email]
    end

    # user account_id
    def account_id
      data[:account_user_id]
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
