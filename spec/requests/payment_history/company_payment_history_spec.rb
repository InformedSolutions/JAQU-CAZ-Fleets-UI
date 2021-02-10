# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #company_payment_history', type: :request do
  subject { get company_payment_history_path, params: { page: 2 } }

  context 'when correct permissions' do
    before do
      mock_actual_account_name
      api_response = read_response('payment_history/payments.json')['1']
      allow(PaymentHistoryApi).to receive(:payments).and_return(api_response)
      sign_in view_payment_history_user
    end

    it 'renders the view' do
      expect(subject).to render_template(:company_payment_history)
    end

    context 'with with invalid page' do
      before do
        allow(PaymentHistoryApi).to receive(:payments).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to the company payment history page' do
        expect(response).to redirect_to company_payment_history_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
