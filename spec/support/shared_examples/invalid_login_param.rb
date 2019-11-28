# frozen_string_literal: true

RSpec.shared_examples 'an invalid login param' do
  it 'renders login view' do
    expect(http_request).to render_template('devise/sessions/new')
  end

  it 'does not call AccountApi.sign_in' do
    expect(AccountsApi).not_to receive(:sign_in)
    http_request
  end
end
