# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::PrimaryUsers - GET #index' do
  subject { get primary_users_path }

  context 'when user is an owner' do
    let(:user) { create_owner }

    before { sign_in user }

    it 'returns 200' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
