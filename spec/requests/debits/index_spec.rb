# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsController - #index' do
  subject(:http_request) { get debits_path }

  before do
    mock_debit(debit)
    sign_in create_user
  end

  context 'with empty debit' do
    let(:debit) { create_empty_debit }

    it 'redirects to debits#new' do
      http_request
      expect(response).to redirect_to(new_debit_path)
    end

    it 'does not check zones' do
      expect(debit).not_to receive(:zones_without_mandate)
      http_request
    end
  end

  context 'with a mandate added' do
    let(:debit) { create_debit }

    it 'returns 200' do
      http_request
      expect(response).to have_http_status(:success)
    end

    it 'checks zones' do
      expect(debit).to receive(:zones_without_mandate)
      http_request
    end
  end
end
