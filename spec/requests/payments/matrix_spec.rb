# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #matrix', type: :request do
  subject(:http_request) { get matrix_payments_path }

  let(:la_id) { SecureRandom.uuid }

  before { sign_in create_user }

  context 'with la in the session' do
    before do
      add_to_session(new_payment: { la_id: la_id })
      http_request
    end

    it 'is successful' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'without la in the session' do
    it 'redirects to index' do
      http_request
      expect(response).to redirect_to(payments_path)
    end
  end
end
