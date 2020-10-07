# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::EmailsController - GET #confirm_email' do
  subject { get confirm_email_primary_users_path }

  context 'when user is an owner' do
    before do
      sign_in create_owner
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:confirm_email)
    end
  end

  context 'when user is not an owner' do
    before { sign_in create_user }

    it 'redirects to the not found page' do
      expect(subject).to redirect_to(not_found_path)
    end
  end
end
