# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::SelectCaz do
  subject do
    described_class.new(session: session, user: user, current_id: current_id, new_id: new_id).call
  end

  let(:selected_zones_in_sesssion) { session[:selected_zones_ids] }
  let(:current_id) { SecureRandom.uuid }
  let(:new_id) { SecureRandom.uuid }
  let(:session) { { selected_zones_ids: [SecureRandom.uuid, current_id, SecureRandom.uuid] } }
  let(:user) { create_user }

  before do
    mock_clean_air_zones
    mock_update_user
    subject
  end

  context 'with ids provided' do
    it 'does not remove uuids form the session' do
      expect(session[:selected_zones_ids].count).to eq(3)
    end

    it 'exchange the current_id with new_id' do
      expect(session[:selected_zones_ids][1]).to eq(new_id)
    end

    it 'updates user through API' do
      expect(AccountsApi::Users).to have_received(:update_user)
    end
  end

  describe 'when current_id was not provided' do
    let(:current_id) { nil }

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end

  describe 'when new_id was not provided' do
    let(:new_id) { nil }

    it 'does not update user through API' do
      expect(AccountsApi::Users).not_to have_received(:update_user)
    end
  end
end
