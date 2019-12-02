# frozen_string_literal: true

Given('I go to the create account page') do
  mock_verification_email
  visit create_account_name_path
end

Then('I enter a company name') do
  fill_in('organisations_company_name', with: 'Company name')
end

And('I enter the account details') do
  fill_in('organisations_email', with: 'example@email.com')
  fill_in('organisations_email_confirmation', with: 'example@email.com')
  fill_in('organisations_password', with: 'CboD9%1Q')
  fill_in('organisations_password_confirmation', with: 'CboD9%1Q')
end

When('I go to the email verified page') do
  visit email_verified_path
end

Then('I should receive verification email') do
  expect(Sqs::VerificationEmail).to have_received(:call)
end
