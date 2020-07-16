# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
describe 'PaymentsController - POST #confirm_payment_method' do
=======
describe 'PaymentsController - POST #confirm_payment_method', type: :request do
>>>>>>> release-candidate/v1.2.0
  subject { post select_payment_method_payments_path, params: { payment_method: payment_method } }

  let(:payment_method) { 'false' }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { la_id: @uuid, details: {} })
      allow(PaymentsApi).to receive(:create_payment).and_return(
<<<<<<< HEAD
        'paymentId' => @uuid,
=======
        'paymentId' => SecureRandom.uuid,
>>>>>>> release-candidate/v1.2.0
        'nextUrl' => result_payments_path
      )
      sign_in create_user
      subject
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

  it_behaves_like 'incorrect permissions'
end
