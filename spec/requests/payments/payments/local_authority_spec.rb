# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #index', type: :request do
  subject { post local_authority_payments_path, params: { 'local-authority' => la } }

  let(:la) { SecureRandom.uuid }

  context 'correct permissions' do
    let(:chargeable_vehicles_exists) { true }

    before do
      fleet_mock = instance_double('ManageVehicles::Fleet',
                                   any_chargeable_vehicles_in_caz?: chargeable_vehicles_exists)
      allow(ManageVehicles::Fleet).to receive(:new).and_return(fleet_mock)
      sign_in create_user
      subject
    end

    context 'when user selects the LA' do
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

      it 'saves la in the session' do
        expect(session[:new_payment][:la_id]).to eq(la)
      end
    end

    context 'when user does not select the LA' do
      let(:la) { nil }

      it 'redirects to index' do
        expect(response).to redirect_to(payments_path)
      end

      it 'does not save la in the session' do
        expect(session[:new_payment]).to be_nil
      end

      it 'returns an alert' do
        expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
