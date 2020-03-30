# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - POST #initiate' do
  subject(:http_request) do
    post initiate_debits_path
  end

  before do
    add_to_session(new_payment: { la_id: SecureRandom.uuid })
    response = read_response('/debits/create_payment.json')
    allow(MakeDebitPayment).to receive(:call).and_return(response)
    sign_in create_user
    http_request
  end

  it 'redirects to the success payment page' do
    http_request
    expect(response).to redirect_to(success_payments_path)
  end
end
