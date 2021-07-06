# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #clear_search', type: :request do
  subject { get clear_search_payments_path }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(payment_query: { search: 'search' })
      subject
    end

    it 'clears `search` in session' do
      expect(session.dig(:payment_query, :search)).to be_nil
    end

    it 'redirects to matrix page' do
      expect(response).to redirect_to(matrix_payments_path)
    end
  end

  it_behaves_like 'incorrect permissions'
end
