# frozen_string_literal: true


module Devise
  module Strategies
    ##
    # Class responsible for validating user email and authenticating user.
    #
    class Remote < Devise::Strategies::Authenticatable
      # For an example check:
      # https://github.com/plataformatec/devise/blob/master/lib/devise/strategies/database_authenticatable.rb
      # Method called by warden to authenticate a resource.
      def authenticate!
        return fail! unless validate_login_form

        # mapping.to is a wrapper over the resource model
        resource = mapping.to.new
        return fail! unless resource

        authenticate_user(resource, params_auth_hash)
      end

      # Validation are made by LoginForm
      def valid?
        params_authenticatable? && valid_params_request? && valid_params?
      end

      private

      def validate_login_form
        form = LoginForm.new(params_auth_hash[:email], params_auth_hash[:password])
        return true if form.valid?

        form.errors.each { |field, msg| errors.add(field, msg) }
        false
      end

      def authenticate_user(resource, auth_params)
        # remote_authentication method is defined in Devise::Models::RemoteAuthenticatable
        #
        # validate is a method defined in Devise::Strategies::Authenticatable. It takes
        # a block which must return a boolean value.
        #
        # If the block returns true the resource will be logged in
        # If the block returns false the authentication will fail!
        #
        if validate(resource) { resource = resource.authentication(auth_params) }
          success!(resource)
        else
          errors.add(:base, I18n.t('login_form.incorrect'))
          errors.add(:email, I18n.t('login_form.email_missing'))
          errors.add(:password, I18n.t('login_form.password_missing'))
          fail!(:invalid)
        end
      end
    end
  end
end
