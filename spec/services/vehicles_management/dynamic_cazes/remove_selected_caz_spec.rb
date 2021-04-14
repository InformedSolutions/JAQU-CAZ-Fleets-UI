# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::RemoveSelectedCaz do
  subject { described_class.new(session: session, user: user, key: key).call }

  let(:bath_key) { SecureRandom.uuid }
  let(:empty_key) { SecureRandom.uuid }
  let(:session) { { fleet_dynamic_zones: fleet_dynamic_zones } }
  let(:fleet_dynamic_zones) do
    {
      empty_key => {},
      bath_key => { 'id' => '44590023-9b0f-450e-8a6a-feed267fea23', 'name' => 'Bath' },
      SecureRandom.uuid => {}
    }
  end
  let(:user) { create_user }

  before do
    mock_clean_air_zones
    mock_update_user
    subject
  end

  describe 'when key was already in fleet_dynamic_zones list' do
    context 'with assigned zone' do
      let(:key) { bath_key }

      it 'removes it from the session' do
        expect(session[:fleet_dynamic_zones].count).to eq(2)
      end

      it 'removes exact id from the session' do
        expect(session[:fleet_dynamic_zones].keys).not_to include(key)
      end

      it 'updates user through API' do
        expect(AccountsApi::Users).to have_received(:update_user)
      end
    end

    context 'without assigned zone' do
      let(:key) { empty_key }

      it 'removes it from the session' do
        expect(session[:fleet_dynamic_zones].count).to eq(2)
      end

      it 'removes exact id from the session' do
        expect(session[:fleet_dynamic_zones]).not_to include(empty_key)
      end

      it 'does not update user through API' do
        expect(AccountsApi::Users).not_to have_received(:update_user)
      end
    end
  end

  describe 'when id was not present in fleet_dynamic_zones list' do
    let(:key) { SecureRandom.uuid }

    it 'does not remove any id from the session' do
      expect(session[:fleet_dynamic_zones].count).to eq(3)
    end

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end

  describe 'when key was not provided' do
    let(:key) { nil }

    it 'does not remove any id from the session' do
      expect(session[:fleet_dynamic_zones].count).to eq(3)
    end

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end
end
