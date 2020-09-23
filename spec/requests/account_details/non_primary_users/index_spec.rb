# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::NonPrimaryUsers - GET #index' do
  subject { get non_primary_users_path }

  context 'when user is not owner' do
    let(:user) { create_user }

    before { sign_in user }

    it 'returns 200' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
