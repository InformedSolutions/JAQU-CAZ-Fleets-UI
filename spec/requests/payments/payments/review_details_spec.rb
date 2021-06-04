# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #review_details', type: :request do
  subject { get review_details_payments_path }

  context 'when correct permissions' do
    let(:payment_details) do
      { 'PAY001' =>
        { vrn: 'PAY001',
          tariff: 'BCC01-HEAVY GOODS VEHICLE',
          charge: 50.0,
          dates: ['13 October 2020'] } }
    end

    let(:new_payment_session) do
      {
        new_payment: {
          caz_id: SecureRandom.uuid,
          details: payment_details
        }
      }
    end

    context 'when there are no sufficient data in session' do
      before do
        sign_in create_user
        subject
      end

      it 'does not assign :details variable' do
        expect(assigns(:details)).to eq(nil)
      end

      it 'redirects to ' do
        expect(response).to redirect_to(payments_path)
      end
    end

    context 'when there are correct data in session' do
      before do
        sign_in create_user
        add_to_session(new_payment_session)
        subject
      end

      it 'assigns :details variable' do
        expect(assigns(:details)).to eq(payment_details)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
