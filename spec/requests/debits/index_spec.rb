# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - GET #index' do
  subject { get debits_path }

  before { sign_in create_user }

  context 'when zones have the active mandates' do
    before { mock_debits }

    it 'returns 200' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'when zones does not have the active mandates' do
    before { mock_debits('empty_mandates') }

    it 'redirects to create debits page' do
      subject
      expect(response).to redirect_to(new_debit_path)
    end
  end
end
