# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::RemoveSelectedCaz do
  subject { described_class.new(session: session, user: user, id: selected_zone_id).call }

  let(:selected_zones_in_sesssion) { session[:selected_zones_ids] }
  let(:existing_zone_id) { SecureRandom.uuid }
  let(:selected_zone_id) { existing_zone_id }
  let(:session) { { selected_zones_ids: [existing_zone_id, SecureRandom.uuid] } }
  let(:user) { create_user }

  before do
    mock_clean_air_zones
    mock_update_user
    subject
  end

  describe 'when id was already in selected_zones_ids list' do
    context 'with id from existisng CAZ' do
      let(:existing_zone_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' } # Birmingham

      it 'removes it from the session' do
        expect(session[:selected_zones_ids].count).to eq(1)
      end

      it 'removes exact id from the session' do
        expect(session[:selected_zones_ids]).not_to include(selected_zone_id)
      end

      it 'updates user through API' do
        expect(AccountsApi::Users).to have_received(:update_user)
      end
    end

    context 'with id with' do
      it 'removes it from the session' do
        expect(session[:selected_zones_ids].count).to eq(1)
      end

      it 'removes exact id from the session' do
        expect(session[:selected_zones_ids]).not_to include(selected_zone_id)
      end

      it 'does not update user through API' do
        expect(AccountsApi::Users).not_to have_received(:update_user)
      end
    end
  end

  describe 'when id was not present in selected_zones_ids list' do
    let(:selected_zone_id) { SecureRandom.uuid }

    it 'does not remove any id from the session' do
      expect(session[:selected_zones_ids].count).to eq(2)
    end

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end

  describe 'when id was not provided' do
    let(:selected_zone_id) { nil }

    it 'does not remove any id from the session' do
      expect(session[:selected_zones_ids].count).to eq(2)
    end

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end
end
