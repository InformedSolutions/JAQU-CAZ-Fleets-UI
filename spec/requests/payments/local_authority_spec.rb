# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #index', type: :request do
  subject(:http_request) do
    post local_authority_payments_path, params: { 'local-authority' => la }
  end

  let(:la) { SecureRandom.uuid }

  before do
    sign_in create_user
    http_request
  end

  context 'when user selects the LA' do
    it 'redirects to matrix' do
      expect(response).to redirect_to(matrix_payments_path)
    end

    it 'saves la in the session' do
      expect(session[:new_payment][:la_id]).to eq(la)
    end
  end

  context 'when user does not select the LA' do
    let(:la) { nil }

    it 'redirects to index' do
      expect(response).to redirect_to(payments_path)
    end

    it 'does not save la in the session' do
      expect(session[:new_payment]).to be_nil
    end

    it 'returns an alert' do
      expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
    end
  end
end
