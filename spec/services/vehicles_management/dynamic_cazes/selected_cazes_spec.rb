# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::SelectedCazes do
  subject do
    described_class.new(session: session, user: user).call
  end

  let(:selected_zones_in_sesssion) { session[:selected_zones_ids] }
  let(:user) { create_user }

  before { mock_user_details }

  context 'when :selected_zones_ids is present in session' do
    let(:session) { { selected_zones_ids: [SecureRandom.uuid] } }

    it 'returns array from session' do
      expect(subject).to eq(session[:selected_zones_ids])
    end

    it 'does not call AccountsApi for the details' do
      subject
      expect(AccountsApi::Users).not_to have_received(:user)
    end
  end

  describe 'when current_id was not provided' do
    let(:session) { {} }

    it 'returns array from AccountsApi' do
      expect(subject).to eq(['5cd7441d-766f-48ff-b8ad-1809586fea37'])
    end

    it 'calls AccountsApi for the details' do
      subject
      expect(AccountsApi::Users).to have_received(:user)
    end
  end
end
