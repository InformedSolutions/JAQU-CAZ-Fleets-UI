# frozen_string_literal: true

module SignInHelper
  def login_user
    user = new_user
    allow(AccountsApi).to receive(:sign_in).and_return(user)

    fill_sign_in_form
  end

  def login_admin
    admin = new_user(admin: true)
    allow(AccountsApi).to receive(:sign_in).and_return(admin)

    fill_sign_in_form
  end

  private

  def new_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      admin: options[:admin] || false,
      user_id: options[:user_id] || SecureRandom.uuid,
      account_id: options[:account_id] || SecureRandom.uuid,
      account_name: options[:account_name] || 'Royal Mail'
    )
  end

  def fill_sign_in_form
    visit new_user_session_path
    fill_in('user_email', with: 'user@example.com')
    fill_in('user_password', with: 'password')
    click_button 'Continue'
  end
end

World(SignInHelper)
