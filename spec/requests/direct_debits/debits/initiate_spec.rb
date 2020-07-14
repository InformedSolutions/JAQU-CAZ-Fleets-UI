# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - POST #initiate' do
  subject { post initiate_debits_path }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { la_id: @uuid })
      allow(Payments::MakeDebitPayment).to receive(:call)
        .and_return(read_response('/debits/create_payment.json'))
      sign_in make_payments_user
      subject
    end

    it 'redirects to the success payment page' do
      expect(response).to redirect_to(success_debits_path)
    end
  end

  it_behaves_like 'incorrect permissions'
end
