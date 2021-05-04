# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::SelectedCazes do
  subject do
    described_class.new(session: session, user: user).call
  end

  let(:user) { create_user }

  before { mock_clean_air_zones }

  context 'when :fleet_dynamic_zones is present in session' do
    let(:session) { { fleet_dynamic_zones: { SecureRandom.uuid => {} } } }

    before { mock_user_details }

    it 'returns array from session' do
      expect(subject).to eq(session[:fleet_dynamic_zones])
    end

    it 'does not call AccountsApi for the details' do
      subject
      expect(AccountsApi::Users).not_to have_received(:user)
    end
  end

  context 'when :fleet_dynamic_zones is not present in session' do
    let(:session) { {} }

    context 'when user has already selected caz before' do
      before { mock_user_details }

      it 'returns one selected caz based on AccountsApi' do
        expect(subject.count).to eq(1)
      end

      it 'returns loads selected cazes based on AccountsApi' do
        expect(subject.first[1]).to eq(
          { 'id' => '5cd7441d-766f-48ff-b8ad-1809586fea37', 'name' => 'Birmingham' }
        )
      end

      it 'calls AccountsApi for the details' do
        subject
        expect(AccountsApi::Users).to have_received(:user)
      end
    end

    context 'when user has not selected caz before' do
      before { mock_user_details_with_empty_selected_cases }

      it 'returns one selected caz based on AccountsApi' do
        expect(subject.count).to eq(1)
      end

      it 'returns loads selected cazes based on AccountsApi' do
        expect(subject.first[1]).to be_blank
      end

      it 'calls AccountsApi for the details' do
        subject
        expect(AccountsApi::Users).to have_received(:user)
      end
    end
  end
end
