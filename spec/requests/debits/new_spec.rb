# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - #new' do
  subject(:http_request) { get new_debit_path }

  let(:debit) { create_debit(zones: zones) }
  let(:zones) { [] }

  before do
    mock_debit(debit)
    sign_in(create_user)
  end

  context 'when no available zones to choose' do
    it 'redirects to debits#index' do
      http_request
      expect(response).to redirect_to(debits_path)
    end
  end

  context 'with available zones to add' do
    let(:zones) do
      read_response('caz_list.json')['cleanAirZones'].map { |zone| CleanAirZone.new(zone) }
    end

    it 'returns 200' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
