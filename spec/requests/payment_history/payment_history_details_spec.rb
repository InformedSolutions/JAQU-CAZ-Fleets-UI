# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #payment_history_details' do
  subject { get payment_history_details_path, params: { payment_id: @uuid } }

  context 'correct permissions' do
    before do
      api_response = read_response('payment_history/payment_details.json')
      allow(PaymentHistoryApi).to receive(:payment_details).and_return(api_response)
      sign_in make_payments_user
    end

    it 'renders the view' do
      expect(subject).to render_template('payment_history_details')
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
