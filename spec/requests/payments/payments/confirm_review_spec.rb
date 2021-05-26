# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #confirm_review', type: :request do
  subject do
    post confirm_review_payments_path, params: {
      confirm_not_exemption: confirm_not_exemption,
      direct_debit_enabled: direct_debit_enabled
    }
  end

  let(:confirm_not_exemption) { 'yes' }
  let(:direct_debit_enabled) { 'true' }

  context 'when correct permissions' do
    let(:payment_details) do
      { caz_id: '131af03c-f7f4-4aef-81ee-aae4f56dbeb5', details: {
        'PAY001' => { vrn: 'PAY001', charge: 100.0, dates: ['13 October 2020'] }
      } }
    end

    before do
      add_to_session(new_payment: payment_details)
      sign_in create_user
      subject
    end

    context 'when direct_debit_enabled is true' do
      it 'saves not exemption confirmation to session' do
        expect(session[:new_payment]['confirm_not_exemption']).to eq('yes')
      end

      it 'redirects to select payment method page' do
        expect(response).to redirect_to(select_payment_method_payments_path)
      end
    end

    context 'when direct_debit_enabled is false' do
      let(:direct_debit_enabled) { 'false' }

      it 'saves not exemption confirmation to session' do
        expect(session[:new_payment]['confirm_not_exemption']).to eq('yes')
      end

      it 'redirects to select payment method page' do
        expect(response).to redirect_to(initiate_payments_path)
      end
    end

    context 'with invalid form' do
      let(:confirm_not_exemption) { 'no' }

      before { subject }

      it 'redirects to review page' do
        expect(response).to redirect_to(review_payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
