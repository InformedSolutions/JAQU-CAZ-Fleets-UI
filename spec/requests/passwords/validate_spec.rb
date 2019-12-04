# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordsController - POST #validate' do
  subject { post reset_passwords_path, params: { passwords: { email_address: email_address } } }

  let(:email_address) { 'email@example.com' }

  before { subject }

  context 'with valid params' do
    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'with invalid params' do
    let(:email_address) { '' }

    it 'renders reset password view' do
      expect(response).to render_template('passwords/reset')
    end
  end
end
