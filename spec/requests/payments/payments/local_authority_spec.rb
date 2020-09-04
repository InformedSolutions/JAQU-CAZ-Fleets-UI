# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - POST #local_authority' do
  subject { post local_authority_payments_path, params: { 'caz_id' => caz_id } }

  let(:caz_id) { @uuid }
  let(:user) { make_payments_user }
  let(:caz_lock_key) { "caz_lock_#{user.account_id}_#{caz_id}" }

  context 'correct permissions' do
    let(:chargeable_vehicles_exists) { true }

    before do
      fleet_mock = instance_double('VehiclesManagement::Fleet',
                                   any_chargeable_vehicles_in_caz?: chargeable_vehicles_exists)
      allow(VehiclesManagement::Fleet).to receive(:new).and_return(fleet_mock)
      sign_in user
    end

    context 'when user selects the LA' do
      before { subject }

      context 'when user has chargeable vehicles in the selected CAZ' do
        it 'redirects to matrix' do
          expect(response).to redirect_to(matrix_payments_path)
        end
      end

      context 'when user has no chargeable vehicles in the selected CAZ' do
        let(:chargeable_vehicles_exists) { false }

        it 'redirects to no chargeable vehicles page' do
          expect(response).to redirect_to(no_chargeable_vehicles_payments_path)
        end
      end

      it 'saves caz_id in the session' do
        expect(session[:new_payment][:caz_id]).to eq(caz_id)
      end
    end

    context 'when user does not select the LA' do
      let(:caz_id) { nil }

      before { subject }

      it 'redirects to index' do
        expect(response).to redirect_to(payments_path)
      end

      it 'does not save caz_id in the session' do
        expect(session[:new_payment]).to be_nil
      end

      it 'returns an alert' do
        expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
      end
    end

    context 'when CAZ locked by another user' do
      before do
        add_caz_lock_to_redis(SecureRandom.uuid)
        add_to_session(new_payment: { caz_id: caz_id })
        subject
      end

      it 'redirects to payment in progress page' do
        expect(response).to redirect_to(in_progress_payments_path)
      end

      it 'not removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_key, 'caz_id')).to_not be_nil
      end
    end

    context 'when CAZ locked by current user' do
      before do
        add_caz_lock_to_redis(user.user_id)
        add_to_session(new_payment: { caz_id: caz_id })
        subject
      end

      it 'redirects to matrix page' do
        expect(response).to redirect_to(matrix_payments_path)
      end

      it 'not removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_key, 'caz_id')).to_not be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
