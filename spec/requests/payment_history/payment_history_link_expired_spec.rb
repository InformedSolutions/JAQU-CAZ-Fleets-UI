# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #payment_history_link_expired', type: :request do
  subject { get payment_history_link_expired_path }

  context 'when correct permissions' do
    before { sign_in user }

    let(:user) { view_payment_history_user }

    it_behaves_like 'a static page'
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
