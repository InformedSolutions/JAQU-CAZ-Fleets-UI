# frozen_string_literal: true

When('I want to see my account details') do
  mock_user_details
  first(:link, 'Account details').click
end

And('I want to change my password') do
  all('.govuk-summary-list__row')[2].find('.govuk-link').click
end

And('I should be on primary user account details page') do
  expect(page).to have_current_path(primary_users_account_details_path)
end

And('I should be on non primary user account details page') do
  expect(page).to have_current_path(non_primary_users_account_details_path)
end

And('I should be on account details update password page') do
  expect(page).to have_current_path(edit_password_path)
end
