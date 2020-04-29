# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - GET #new' do
  subject(:http_request) { get new_debit_path }

  before { sign_in create_user }

  context 'with available zones to add a new mandate' do
    before { mock_debits }

    it 'returns 200' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  context 'when all zones have the active mandates' do
    before { mock_debits('active_mandates') }

    it 'redirects to the list of Direct Debits' do
      http_request
      expect(response).to redirect_to(debits_path)
    end
  end
end
