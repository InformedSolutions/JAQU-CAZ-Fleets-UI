# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #index' do
  subject { get debits_path }

  context 'correct permissions' do
    before { sign_in manage_mandates_user }

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

  it_behaves_like 'incorrect permissions'
end
