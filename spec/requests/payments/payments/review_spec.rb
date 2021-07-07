# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #review', type: :request do
  subject { get review_payments_path }

  context 'when correct permissions' do
    before do
      mock_clean_air_zones
      mock_chargeable_vehicles
      add_to_session(new_payment: { caz_id: mocked_uuid,
                                    details: { mocked_vrn => { dates: %w[2019-11-05 2019-11-06],
                                                               charge: 50 } } })
    end

    context 'when user is not beta tester' do
      context 'when :total_to_pay is < Payments::Constants::CHARGE_LIMIT' do
        before do
          sign_in(create_user(beta_tester: false))
          subject
        end

        it 'calls ComplianceCheckerApi for CAZ name' do
          expect(ComplianceCheckerApi).to have_received(:clean_air_zones)
        end

        it 'assigns :zone variable' do
          expect(assigns(:zone).name).to eq('Birmingham')
        end

        it 'assigns correct value to session' do
          expect(session.dig(:new_payment, 'direct_debit_enabled')).to be_truthy
        end

        it 'assigns :days_to_pay variable' do
          expect(assigns(:days_to_pay)).to eq(2)
        end

        it 'assigns :total_to_pay variable' do
          expect(assigns(:total_to_pay)).to eq(100)
        end

        it 'not assigns flash message' do
          expect(flash[:alert]).to eq(nil)
        end
      end

      context 'when :total_to_pay is > Payments::Constants::CHARGE_LIMIT' do
        before do
          stub_const('Payments::Constants::CHARGE_LIMIT', 0)
          sign_in(create_user(beta_tester: false))
          subject
        end

        it 'assigns flash message' do
          expect(flash[:alert][:limit_exceeded_alert])
            .to eq(I18n.t('payment_review.errors.limit_exceeded_alert'))
        end
      end
    end

    context 'when user is beta tester' do
      before { sign_in(create_user(beta_tester: true)) }

      it 'assigns correct value to session' do
        subject
        expect(session.dig(:new_payment, 'direct_debit_enabled')).to be_truthy
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
