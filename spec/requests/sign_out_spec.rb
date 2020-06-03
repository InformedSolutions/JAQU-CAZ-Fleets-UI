# frozen_string_literal: true

require 'rails_helper'

describe 'Sign out', type: :request do
  subject { delete destroy_user_session_url }

  before do
    sign_in create_owner
    subject
  end

  it 'redirects to sign out page' do
    expect(response).to redirect_to(sign_out_path)
  end
end
