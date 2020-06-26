# frozen_string_literal: true

RSpec.shared_examples 'a login required' do
  it 'returns redirect to the login page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before { sign_in create_user }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
