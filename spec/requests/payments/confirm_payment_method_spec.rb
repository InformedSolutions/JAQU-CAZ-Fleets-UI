# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #confirm_payment_method', type: :request do
  subject(:http_request) do
    post select_payment_method_payments_path, params: { payment_method: payment_method }
  end

  let(:payment_method) { 'false' }
  let(:la_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' }

  before do
    add_to_session(new_payment: { la_id: la_id, details: {} })
    allow(PaymentsApi).to receive(:create_payment).and_return(
      'paymentId' => '294a5714-bf0f-4972-84cf-6ff6c967d22a',
      'nextUrl' => result_payments_path
    )
    sign_in create_user
    http_request
  end

  context 'when user selects the Card payment method' do
    it 'redirects to initiate payment path' do
      expect(response).to redirect_to(initiate_payments_path)
    end
  end

  context 'when user selects the Direct Debit method' do
    let(:payment_method) { 'true' }

    it 'redirects to confirm Direct Debit payment page' do
      expect(response).to redirect_to(confirm_debits_path)
    end
  end
end
