# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - GET #first_mandate' do
  subject(:http_request) { get first_mandate_debits_path }

  before do
    add_to_session(new_payment: { la_id: SecureRandom.uuid, details: {} })
    sign_in create_user
    http_request
  end

  it 'returns 200' do
    expect(response).to have_http_status(:success)
  end
end
