# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding user management.
# See {FleetsApi}[rdoc-ref:FleetsApi] for fleet related actions.
#
class AccountsApi < BaseApi
  base_uri ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001') + '/v1'

  class << self
    ##
    # Calls +/v1/auth/login+ endpoint with +POST+ method and returns details of the user.
    #
    # ==== Attributes
    #
    # * +email+ - submitted email address
    # * +password+ - submitted password
    #
    # ==== Example
    #
    #     user_attributes = AccountsApi.sign_in(email: 'test@example.com', password: 'test')
    #     user = User.serialize_from_api(user_attributes)
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +accountId+ - uuid, ID of the account on backend DB
    # * +accountName+ - string, name of the account
    # * +accountUserId+ - uuid, ID of the accountUser on backend DB
    # * +admin+ - boolean, determines if the user is admin
    # * +email+ = email, email of the accountUser
    #
    # ==== Serialization
    #
    # {User model}[rdoc-ref:User] can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {401 Exception}[rdoc-ref:BaseApi::Error401Exception] - email and password do not match
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - email is not confirmed
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def sign_in(email:, password:)
      log_action('Login the user')
      body = { email: email.downcase, password: password }.to_json
      request(:post, '/auth/login', body: body)
    end

    ##
    # Calls +/v1/accounts+ endpoint with +POST+ method and returns details of the user.
    #
    # ==== Attributes
    #
    # * +company_name+ - submitted name of the account
    # * +email+ - submitted email address
    # * +password+ - submitted password
    #
    # ==== Example
    #
    #     user_attributes = AccountsApi.create_account(
    #       company_name: 'Test Inc.', email: 'test@example.com', password: 'test'
    #     )
    #     user = User.serialize_from_api(user_attributes)
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +accountId+ - uuid, ID of the account on backend DB
    # * +accountName+ - string, name of the account
    # * +accountUserId+ - uuid, ID of the accountUser on backend DB
    # * +admin+ - boolean, determines if the user is admin
    # * +email+ = email, email of the accountUser
    #
    # ==== Serialization
    #
    # {User model}[rdoc-ref:User] can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - parameters are invalid (details in the exception body)
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def create_account(email:, password:, company_name:)
      log_action("Creating account with company_name: #{company_name}")
      body = { accountName: company_name, email: email.downcase, password: password }.to_json
      request(:post, '/accounts', body: body)
    end

    ##
    # Calls +/v1/accounts/:accountId/users/:accountUserId/verify+ endpoint with +POST+ method.
    #
    # ==== Attributes
    #
    # * +account_id+ - uuid, ID of the account on backend DB
    # * +user_id+ - uuid, ID of the accountUser on backend DB
    #
    # ==== Example
    #
    #    AccountsApi.verify_user(account_id: user.account_id, user_id: user.user_id)
    #
    # ==== Result
    #
    # Returns an empty body
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - email already confirmed
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def verify_user(account_id:, user_id:)
      log_action('Verifying the user account')
      request(:post, "/accounts/#{account_id}/users/#{user_id}/verify")
    end

    ##
    # Calls +/v1/auth/password/reset+ endpoint with +POST+ method.
    #
    # ==== Attributes
    #
    # * +email+ - email, email address submitted by the user
    #
    # ==== Example
    #
    #    AccountsApi.initiate_password_reset(email: 'test@example.com')
    #
    # ==== Result
    #
    # Returns true if the call was successful
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid email address
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def initiate_password_reset(email:, reset_url:)
      log_action('Initiating password reset')
      body = { email: email, resetUrl: reset_url }.to_json
      request(:post, '/auth/password/reset', body: body)
      true
    end

    ##
    # Calls +/v1/auth/password/reset/validation+ endpoint with +POST+ method.
    #
    # ==== Attributes
    #
    # * +token+ - uuid, token from reset password link
    #
    # ==== Example
    #
    #    AccountsApi.validate_password_reset(token:)
    #
    # ==== Result
    #
    # Returns true if the call was successful
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid or expired token
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def validate_password_reset(token:)
      log_action('Validating password reset token')
      body = { token: token }.to_json
      request(:post, '/auth/password/reset/validation', body: body)
      true
    end

    ##
    # Calls +/v1/auth/password/set/+ endpoint with +PUT+ method.
    #
    # ==== Attributes
    #
    # * +token+ - uuid, token from reset password link
    # * +password+ - string, new password value submitted by the user
    #
    # ==== Example
    #
    #    AccountsApi.set_password(
    #       token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69',
    #       password: 'Password1234!'
    #    )
    #
    # ==== Result
    #
    # Returns true if the call was successful
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid or expired token
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid password
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def set_password(token:, password:)
      log_action('Setting a new password')
      body = { token: token, password: password }.to_json
      request(:put, '/auth/password/set', body: body)
      true
    end
  end
end
