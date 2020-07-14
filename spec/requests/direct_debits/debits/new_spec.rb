# frozen_string_literal: true

require 'rails_helper'

describe 'DirectDebits::DebitsController - GET #new' do
  subject { get new_debit_path }

  context 'correct permissions' do
    before { sign_in manage_mandates_user }

    context 'with available zones to add a new mandate' do
      before { mock_debits }

      it 'returns 200' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'when all zones have the active mandates' do
      before { mock_debits('active_mandates') }

      it 'redirects to the list of Direct Debits' do
        subject
        expect(response).to redirect_to(debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
