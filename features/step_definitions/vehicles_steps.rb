# frozen_string_literal: true

When('I visit the enter details page') do
  login_user
  visit enter_details_vehicles_path
end

When('I enter vrn') do
  fill_in('vrn', with: 'CU57ABC')
end

Then('I should be on the enter details page') do
  expect(page).to have_current_path(enter_details_vehicles_path)
end

Then('I should be on the confirm details page') do
  expect(page).to have_current_path(confirm_details_vehicles_path)
end
