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
  allow(VerifyAccount).to receive(:call).and_raise(UserAlreadyConfirmedException)
  visit email_verification_organisations_path(token: SecureRandom.uuid)
end

Then('I enter a company name') do
  fill_in('organisations_company_name', with: 'Company name')
end

And('I enter the account details') do
  allow(AccountsApi).to receive(:create_user).and_return(read_response('create_user.json'))
  fill_account_details
end

And('I enter the account details with not uniq email address') do
  stub_request(:post, /users/).to_return(
    status: 422,
    body: {
      'message': 'Submitted parameters are invalid',
      'errorCode': 'emailNotUnique'
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
