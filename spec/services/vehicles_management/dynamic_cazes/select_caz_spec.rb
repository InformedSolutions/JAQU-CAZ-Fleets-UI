# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::SelectCaz do
  subject do
    described_class.new(session: session, user: user, key: key, zone_id: zone_id).call
  end

  let(:selected_zones_in_sesssion) { session[:fleet_dynamic_zones] }
  let(:key) { SecureRandom.uuid }
  let(:zone_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' } # Birmingham
  let(:session) { { fleet_dynamic_zones: fleet_dynamic_zones } }
  let(:fleet_dynamic_zones) do
    {
      SecureRandom.uuid => {},
      key => { 'id' => '44590023-9b0f-450e-8a6a-feed267fea23', 'name' => 'Bath' },
      SecureRandom.uuid => {}
    }
  end
  let(:user) { create_user }

  before do
    mock_clean_air_zones
    mock_update_user
    subject
  end

  context 'with ids provided' do
    it 'does not remove keys form the session' do
      expect(session[:fleet_dynamic_zones].count).to eq(3)
    end

    it 'exchange the zone_id for selected key' do
      expect(session[:fleet_dynamic_zones][key]).to eq(
        { 'id' => zone_id, 'name' => 'Birmingham' }
      )
    end

    it 'updates user through API' do
      expect(AccountsApi::Users).to have_received(:update_user)
    end
  end

  describe 'when key was not provided' do
    let(:key) { nil }

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end

  describe 'when zone_id was not provided' do
    let(:zone_id) { nil }

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end
end
