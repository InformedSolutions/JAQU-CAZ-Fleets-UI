# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Represents the virtual model of the user, used in +../non_primary_users/non_primary_account_details.html.haml+.
  #
  class User
    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # user name
    def name
      data[:name]
    end

    # downcase user email
    def email
      data[:email].downcase
    end

    private

    # Reader for data hash
    attr_accessor :data
  end
end
