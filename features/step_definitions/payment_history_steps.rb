# frozen_string_literal: true

Given('I visit the Company payment history page') do
  mock_api_on_payment_history
  mock_clean_air_zones
  mock_debits
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_path
end

Given('I go to the Company payment history page') do
  mock_debits
  visit payment_history_path
end

Given('I want visit the Payments details page from Company payments history page') do
  mock_users
  mock_api_and_sign_in_user
  visit payment_history_path
end

Given('I visit payment history page to download CSV') do
  mock_api_on_payment_history
  mock_clean_air_zones
  mock_debits
  mock_payment_history_download_initialization
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_path
end

Given('I am attempting to download payment history from a valid link') do
  travel_to(Time.parse('2021-04-23T085031Z').utc)
  mock_clean_air_zones
  mock_api_on_payment_history
  mock_debits
  mock_payment_history_export_status
  mock_found_file_on_s3
  login_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735', permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_export_path('exportId' => SecureRandom.uuid)
end

Given('I am attempting to download payment history from an expired link') do
  travel_to(Time.parse('2021-07-24T085031Z').utc)
  mock_clean_air_zones
  mock_api_on_payment_history
  mock_debits
  mock_payment_history_export_status
  mock_found_file_on_s3
  login_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735', permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_export_path('exportId' => SecureRandom.uuid)
end

Given('I am attempting to download payment history from other user link') do
  travel_to(Time.parse('2021-04-23T085031Z').utc)
  mock_clean_air_zones
  mock_api_on_payment_history
  mock_debits
  mock_payment_history_export_status
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_export_path('exportId' => SecureRandom.uuid)
end

Then('I am redirected do download payment history page') do
  expect_path(payment_history_download_path)
end

Then('I am redirected to link expired page') do
  expect_path(payment_history_link_expired_path)
end

Then('I am redirected to no access to link page') do
  expect_path(payment_history_link_no_access_path)
end

Then('I should be on the the Company payment history page') do
  expect_path(payment_history_path)
end

And('I should be on the Payment history page number {int}') do |page_number|
  expect(page).to have_current_path("#{payment_history_url}?page=#{page_number}")
end

And('I should be on the Payment history page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{payment_history_url}?page=#{page_number}?back=true")
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

Then('I should be on the the Payment details history page') do
  expect_path("#{payment_history_details_path}?payment_id=b1f14586-d024-11ea-afe0-47fd231cac0c")
end

private

def mock_payment_history(page = 1)
  allow(PaymentHistory::History).to receive(:new).and_return(create_history(page))
end

def mock_empty_payment_history
  allow(PaymentHistory::History).to receive(:new).and_return(create_empty_history)
end

def create_empty_history
  instance_double(PaymentHistory::History, pagination: empty_payments_history_page)
end

def create_history(page)
  instance_double(PaymentHistory::History, pagination: paginated_history(page))
end

def paginated_history(page = 1)
  instance_double(
    PaymentHistory::PaginatedPayment,
    payments_list: payments_list, page: page, total_pages: 5, range_start: 1, range_end: 10,
    total_payments_count: 52, results_per_page: [10, 20, 30, 40, 50]
  )
end

def empty_payments_history_page
  instance_double(
    PaymentHistory::PaginatedPayment,
    payments_list: [], page: 1, total_pages: 0, range_start: 1, range_end: 10,
    total_payments_count: 0, results_per_page: [10, 20, 30, 40, 50]
  )
end

def found_s3_file
  instance_double('Aws::S3::Types::GetObjectOutput',
                  last_modified: Time.parse('2021-04-22T085031').utc,
                  content_type: 'text/csv', body: 'file_body')
end

def payments_list
  api_response.map { |data| PaymentHistory::Payment.new(data) }
end

def api_response
  read_response('payment_history/payments.json')['1']['payments']
end

def mock_api_and_sign_in_user
  mock_api_on_payment_history
  mock_payment_details_history
  mock_clean_air_zones
  mock_debits
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
end

def mock_payment_details_history
  api_response = read_response('payment_history/payment_details.json')
  allow(PaymentHistoryApi).to receive(:payment_details).and_return(api_response)
end

def mock_api_on_payment_history
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_payment_history
  mock_users
end

def mock_found_file_on_s3
  mock = instance_double(Aws::S3::Object, get: found_s3_file)
  allow(Aws::S3::Object).to receive(:new).and_return(mock)
end
