# frozen_string_literal: true

RSpec.shared_examples 'a vrn required view' do
  it 'returns redirect to the login page' do
    http_request
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before { sign_in create_user }

    context 'without VRN in the session' do
      it 'returns redirect to vehicles#enter_details' do
        http_request
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end

    context 'with VRN in the session' do
      before { add_to_session(vrn: @vrn) }

      it 'returns http success' do
        http_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end
