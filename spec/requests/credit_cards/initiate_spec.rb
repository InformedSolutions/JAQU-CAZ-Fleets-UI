# frozen_string_literal: true

require 'rails_helper'

describe 'CreditCardsController - POST #initiate' do
  subject(:http_request) do
    get initiate_payments_path
  end

  before do
    add_to_session(new_payment: { la_id: SecureRandom.uuid })
    response = { 'paymentId' => SecureRandom.uuid, 'nextUrl' => '/payments/result' }
    allow(MakeCardPayment).to receive(:call).and_return(response)
    sign_in create_user
    http_request
  end

  it 'redirects to the result payment page' do
    http_request
    expect(response).to redirect_to(result_payments_path)
  end
end
