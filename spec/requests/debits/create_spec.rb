# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - POST #create' do
  subject(:http_request) do
    post debits_path, params: { 'local-authority' => zone_id }
  end

  let(:zone_id) { SecureRandom.uuid }
  let(:user) { create_user }

  before { sign_in user }

  context 'when user selects the LA' do
    before { mock_debits }

    it 'redirects to index' do
      http_request
      expect(response).to redirect_to(debits_path)
    end

    it 'adds a new mandate' do
      expect(DebitsApi).to receive(:add_mandate).with(
        account_id: user.account_id,
        zone_id: zone_id
      )
      http_request
    end
  end

  context 'when the user does not select option' do
    let(:zone_id) { nil }

    before { http_request }

    it 'redirects to new' do
      expect(response).to redirect_to(new_debit_path)
    end

    it 'sets alert message' do
      expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
    end

    it 'does not add a new mandate' do
      expect(DebitsApi).not_to receive(:add_mandate)
    end
  end
end
