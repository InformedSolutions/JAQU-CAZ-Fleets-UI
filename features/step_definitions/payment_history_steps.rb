# frozen_string_literal: true

Given('I visit the Company payment history page') do
  mock_vehicles_in_fleet
  mock_payment_history
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit company_payment_history_path
end

Given('I go to the Company payment history page') do
  visit company_payment_history_path
end

Given('I go to the User payment history page') do
  visit user_payment_history_path
end

Given('I visit the User payment history page') do
  mock_vehicles_in_fleet
  mock_payment_history
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit user_payment_history_path
end

Then('I should be on the the Company payment history page') do
  expect_path(company_payment_history_path)
end

Then('I should be on the the User payment history page') do
  expect_path(user_payment_history_path)
end

And('I should be on the Company payment history page number {int}') do |page_number|
  expect(page).to have_current_path("#{company_payment_history_url}?page=#{page_number}")
end

And('I should be on the Company payment history page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{company_payment_history_url}?page=#{page_number}?back=true")
end

And('I should be on the User payment history page number {int}') do |page_number|
  expect(page).to have_current_path("#{user_payment_history_url}?page=#{page_number}")
end

And('I should be on the User payment history page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{user_payment_history_url}?page=#{page_number}?back=true")
end

When('I press {int} pagination button on the payment history page') do |selected_page|
  mock_payment_history(selected_page)
  page.find("#pagination-button-#{selected_page}").first('a').click
end

private

def mock_payment_history(page = 1)
  allow(PaymentHistory::History).to receive(:new).and_return(create_history(page))
end

def create_history(page)
  instance_double(PaymentHistory::History, pagination: paginated_history(page))
end

def paginated_history(page = 1)
  instance_double(
    PaymentHistory::PaginatedPayment,
    payments_list: payments_list,
    page: page,
    total_pages: 5,
    range_start: 1,
    range_end: 10,
    total_payments_count: 52
  )
end

def payments_list
  api_response.map { |data| PaymentHistory::Payment.new(data) }
end

def api_response
  read_response('payment_history/payments.json')['1']['payments']
end
