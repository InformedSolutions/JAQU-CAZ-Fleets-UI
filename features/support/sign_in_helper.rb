# frozen_string_literal: true

module SignInHelper
  def login_user
    user = User.new(email: 'email@example.com', sub: SecureRandom.uuid)
    allow(AccountsApi).to receive(:sign_in).and_return(user)

    fill_sign_in_form
  end

  def login_admin
    admin = User.new(email: 'email_admin@example.com', sub: SecureRandom.uuid, admin: true)
    allow(AccountsApi).to receive(:sign_in).and_return(admin)

    fill_sign_in_form
  end

  private

  def fill_sign_in_form
    visit new_user_session_path
    fill_in('user_email', with: 'user@example.com')
    fill_in('user_password', with: 'password')
    click_button 'Continue'
  end
end

World(SignInHelper)
