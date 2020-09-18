# frozen_string_literal: true

RSpec.shared_examples 'an invalid login param' do
  it 'redirects the login view' do
    expect(subject).to render_template('devise/sessions/new')
  end

  it 'does not call AccountApi.sign_in' do
    expect(AccountsApi).not_to receive(:sign_in)
    subject
  end
end
