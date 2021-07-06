# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::RemoveVehicles::UpdateSearchInSession do
  subject { described_class.call(params: params, session: session) }

  let(:params) { { commit: commit, vrn_search: search }.with_indifferent_access }
  let(:commit) { 'SEARCH' }
  let(:search) { 'ABC123' }
  let(:session) { {} }

  context 'when commit is `SEARCH`' do
    let(:commit) { 'SEARCH' }

    it 'updates `remove_vehicles_vrn_search` in session' do
      subject
      expect(session[:remove_vehicles_vrn_search]).to eq(search)
    end
  end

  context 'when commit is `CLEARSEARCH`' do
    let(:commit) { 'CLEARSEARCH' }

    it 'clears `remove_vehicles_vrn_search` in session' do
      subject
      expect(session[:remove_vehicles_vrn_search]).to be_nil
    end
  end
end
