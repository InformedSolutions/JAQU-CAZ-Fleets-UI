# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #cancel', type: :request do
  subject(:http_request) { get cancel_payments_path }

  before do
    add_to_session(new_payment: { la_id: SecureRandom.uuid, details: {} })
    mock_caz_mandates('caz_mandates')
    sign_in create_user
    http_request
  end

  it 'returns 200' do
    expect(response).to have_http_status(:success)
  end

  it 'renders the cancel page' do
    expect(response).to render_template('payments/cancel')
  end
end
