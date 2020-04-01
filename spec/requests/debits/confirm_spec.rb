# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - GET #confirm' do
  subject(:http_request) { get confirm_debits_path }

  before do
    add_to_session(new_payment: { la_id: SecureRandom.uuid, details: {} })
    sign_in create_user
  end

  context 'when zone have some active mandates' do
    before { mock_caz_mandates('caz_mandates') }

    it 'returns 200' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  context 'when zone does not have any active mandates' do
    before { allow(DebitsApi).to receive(:caz_mandates).and_return([]) }

    it 'redirects to the create a first mandate page' do
      http_request
      expect(response).to redirect_to(first_mandate_debits_path)
    end
  end
end
