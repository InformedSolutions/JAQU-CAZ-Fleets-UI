# frozen_string_literal: true

module Sqs
  ##
  # The service used to send the verification email to the user after creating the account.
  #
  # ==== Usage
  #    user = User.new(user_params)
  #    Sqs::VerificationEmail.call(user: user, host: 'http://localhost:3000/')
  #
  class VerificationEmail < Base
    include Rails.application.routes.url_helpers

    # The initializer function.
    #
    # ==== Attributes
    # * +user+ - User, an instance of the User class representing the created user.
    # * +host+ - URL, the website host, used to generate the verification link.
    #
    def initialize(user:, host:)
      @host = host
      @user = user
      template_id = ENV.fetch('NOTIFY_TEMPLATE_ID', '1d4e5cac-4081-4282-83a7-6e89b0f9ae83')
      super(email: user.email, template_id: template_id)
    end

    private

    # Internal variables set in the initializer
    attr_reader :host, :user

    # Creates a hash containing the verification link
    def personalisation
      link_params = { host: host, token: encrypted_token }
      # Adding port for development ENV
      link_params[:port] = 3000 if Rails.env.development?
      { link: email_verification_url(link_params) }
    end

    # Generates token used to identify user after clicking link in the email
    def token
      {
        user_id: user.user_id,
        account_id: user.account_id,
        created_at: Time.current.iso8601,
        salt: SecureRandom.uuid
      }
    end

    # Encrypts token
    def encrypted_token
      Encryption::Encrypt.call(value: token)
    end
  end
end
