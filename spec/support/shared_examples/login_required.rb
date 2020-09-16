# frozen_string_literal: true

RSpec.shared_examples 'a login required' do
  it 'returns redirect to the login page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end
end
