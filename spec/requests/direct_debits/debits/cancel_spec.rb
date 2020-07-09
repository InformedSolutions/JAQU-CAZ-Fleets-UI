# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - #cancel', type: :request do
  subject { get cancel_payments_path }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { la_id: @uuid, details: {} })
      mock_caz_mandates('caz_mandates')
      sign_in create_user
      subject
    end

    it 'returns 200' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the cancel page' do
      expect(response).to render_template('direct_debits/debits/cancel')
    end
  end

  it_behaves_like 'incorrect permissions'
end
