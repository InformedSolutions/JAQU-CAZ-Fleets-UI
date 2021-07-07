# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #select_payment_method', type: :request do
  subject { get select_payment_method_payments_path }

  before { mock_direct_debit_enabled }

  context 'when correct permissions' do
    before { sign_in(create_user) }

    context 'when `direct_debit_enabled` in session is true' do
      before do
        add_to_session(new_payment: { caz_id: SecureRandom.uuid, direct_debit_enabled: true, details: {} })
      end

      context 'when user do not have a Direct Debit set up' do
        before do
          mock_caz_mandates('inactive_caz_mandates')
          subject
        end

        it 'redirects to the initiate payment path' do
          expect(response).to redirect_to(initiate_payments_path)
        end
      end

      context 'when user have a Direct Debit set up' do
        before do
          mock_caz_mandates
          subject
        end

        it 'renders select payment method page' do
          expect(response).to render_template(:select_payment_method)
        end
      end

      context 'when Direct Debits feature disabled' do
        before do
          mock_direct_debit_disabled
          mock_caz_mandates
          subject
        end

        it 'redirects to the initiate payment path' do
          expect(response).to redirect_to(initiate_payments_path)
        end
      end
    end

    context 'when `direct_debit_enabled` in session is nil' do
      before do
        add_to_session(new_payment: { caz_id: SecureRandom.uuid, direct_debit_enabled: false, details: {} })
      end

      context 'when user have a Direct Debit set up' do
        before do
          mock_caz_mandates
          subject
        end

        it 'redirects to the dashboard path' do
          expect(response).to redirect_to(dashboard_path)
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
