# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #select_payment_method', type: :request do
  subject(:http_request) do
    get select_payment_method_payments_path
  end

  before do
    add_to_session(new_payment: { la_id: '5cd7441d-766f-48ff-b8ad-1809586fea37', details: {} })
    sign_in create_user
  end

  context 'when user do not have a Direct Debit set up' do
    before do
      mock_debits('empty_mandates')
      http_request
    end

    it 'redirects to initiate payment path' do
      expect(response).to redirect_to(initiate_payments_path)
    end
  end

  context 'when user have a Direct Debit set up' do
    before do
      mock_debits
      http_request
    end

    it 'renders select payment method page' do
      expect(response).to render_template('payments/select_payment_method')
    end
  end
end
