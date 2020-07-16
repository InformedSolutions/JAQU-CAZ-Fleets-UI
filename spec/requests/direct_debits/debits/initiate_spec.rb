# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
describe 'DirectDebits::DebitsController - POST #initiate' do
=======
describe 'DebitsController - POST #initiate' do
>>>>>>> release-candidate/v1.2.0
  subject { post initiate_debits_path }

  context 'correct permissions' do
    before do
<<<<<<< HEAD
      add_to_session(new_payment: { la_id: @uuid })
      allow(Payments::MakeDebitPayment).to receive(:call)
        .and_return(read_response('/debits/create_payment.json'))
=======
      add_to_session(new_payment: { la_id: SecureRandom.uuid })
      allow(MakeDebitPayment).to receive(:call).and_return(read_response('/debits/create_payment.json'))
>>>>>>> release-candidate/v1.2.0
      sign_in make_payments_user
      subject
    end

    it 'redirects to the success payment page' do
      expect(response).to redirect_to(success_debits_path)
    end
  end

  it_behaves_like 'incorrect permissions'
end
