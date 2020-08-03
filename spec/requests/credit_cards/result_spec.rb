# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - GET #result' do
  subject(:http_request) { get result_payments_path }

  let(:id) { SecureRandom.uuid }
  let(:details) do
    {
      'CU12345' =>
      {
        'vrn' => 'CU12345',
        'tariff' => 'BCC01-HEAVY GOODS VEHICLE',
        'charge' => 50.0,
        'dates' => ['2020-03-26']
      }
    }
  end

  before do
    add_to_session(initiated_payment: { la_id: 'Leeds', payment_id: id, details: details })
    allow(PaymentsApi).to receive(:payment_status)
      .with(payment_id: id, caz_name: 'Leeds').and_return(
        'paymentId' => id, 'status' => 'success', 'userEmail' => 'test@example.com'
      )
    sign_in create_user
    http_request
  end

  it 'redirects to the success page' do
    http_request
    expect(response).to redirect_to(success_payments_path)
  end
end
