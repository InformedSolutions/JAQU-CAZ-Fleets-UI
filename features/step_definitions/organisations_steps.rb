# frozen_string_literal: true

Given('I go to the create account page') do
  mock_verification_email
  visit organisations_path
end

Given('I visit the verification link with a valid token') do
  allow(VerifyAccount).to receive(:call).and_return(true)
  visit email_verification_organisations_path(token: SecureRandom.uuid)
end

Given('I visit the verification link with an invalid token') do
  allow(VerifyAccount).to receive(:call).and_return(false)
  visit email_verification_organisations_path(token: SecureRandom.uuid)
end

Given('I visit the verification link second time') do
  token = Encryption::Encrypt.call(
    value: {
      user_id: 2,
      account_id: 1,
      created_at: Time.current.iso8601,
      salt: SecureRandom.uuid
    }
  )

  stub_request(:post, /verify/).to_return(
    status: 400,
    body: {
      'message': 'User already confirmed'
    }.to_json
  )

  visit email_verification_path(token: token)
end

Then('I enter a company name') do
  fill_in('organisations_company_name', with: 'Company name')
end

And('I enter the account details') do
  allow(AccountsApi).to receive(:create_account).and_return(read_response('create_account.json'))
  fill_account_details
end

And('I enter the account details with not uniq email address') do
  stub_request(:post, /accounts/).to_return(
    status: 422,
    body: {
      'message': 'Submitted parameters are invalid',
      'details': %w[emailNotUnique passwordNotValid emailNotValid]
    }.to_json
  )
  fill_account_details
end

When('I go to the email verified page') do
  visit email_verified_organisations_path
end

Then('I should receive verification email') do
  expect(Sqs::VerificationEmail).to have_received(:call)
end

Then('I should receive verification email again') do
  expect(Sqs::VerificationEmail).to have_received(:call).twice
end

def fill_account_details
  fill_in('organisations_email', with: 'example@email.com')
  fill_in('organisations_email_confirmation', with: 'example@email.com')
  fill_in('organisations_password', with: 'CboD9%1Q')
  fill_in('organisations_password_confirmation', with: 'CboD9%1Q')
end
