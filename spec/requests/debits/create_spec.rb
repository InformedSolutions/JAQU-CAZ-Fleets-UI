# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DebitsController - POST #create' do
  subject(:http_request) do
    post debits_path, params: { 'local-authority' => la }
  end

  let(:la) { SecureRandom.uuid }
  let(:debit) { create_empty_debit }

  before do
    sign_in create_user
    mock_debit(debit)
  end

  context 'when user selects the LA' do
    it 'redirects to index' do
      http_request
      expect(response).to redirect_to(debits_path)
    end

    it 'adds a new mandate' do
      expect(debit).to receive(:add_mandate).with(la)
      http_request
    end
  end

  context 'when the user does not select option' do
    let(:la) { nil }

    it 'redirects to new' do
      http_request
      expect(response).to redirect_to(new_debit_path)
    end

    it 'sets alert message' do
      http_request
      expect(flash[:alert]).to eq(I18n.t('la_form.la_missing'))
    end

    it 'does not add a new mandate' do
      expect(debit).not_to receive(:add_mandate)
      http_request
    end
  end
end
