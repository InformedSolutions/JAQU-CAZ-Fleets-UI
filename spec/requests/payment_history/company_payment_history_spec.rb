# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #company_payment_history' do
  subject { get company_payment_history_path }

  context 'correct permissions' do
    before do
      api_response = read_response('payment_history/payments.json')['1']
      allow(PaymentHistoryApi).to receive(:payments).and_return(api_response)
      sign_in view_payment_history_user
    end

    it 'renders the view' do
      expect(subject).to render_template('company_payment_history')
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
