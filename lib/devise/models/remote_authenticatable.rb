module Devise
  module Models
    module RemoteAuthenticatable
      extend ActiveSupport::Concern
      # Here you do the request to the external webservice
      #
      # If the authentication is successful you should return
      # a resource instance
      #
      # If the authentication fails you should return false
      def authentication(params)
        return false unless params[:password] == 'password'

        User.new(email: params[:email], sub: SecureRandom.uuid)
      end

      module ClassMethods
        # Overridden methods from Devise::Models::Authenticatable
        #
        # This method is called from:
        # Warden::SessionSerializer in devise
        #
        # It takes as many params as elements had the array
        # returned in serialize_into_session
        #
        # Recreates a resource from session data
        def serialize_from_session(data, _salt)
          new(**data.symbolize_keys)
        end

        #
        # Here you have to return and array with the data of your resource
        # that you want to serialize into the session
        #
        # You might want to include some authentication data
        #
        def serialize_into_session(record)
          [record.serializable_hash.stringify_keys, nil]
        end
      end
    end
  end
end
