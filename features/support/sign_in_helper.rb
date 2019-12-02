# frozen_string_literal: true

module SignInHelper
  def login_user
    User.new(email: 'email@example.com', sub: SecureRandom.uuid)
  end

  def login_admin
    User.new(email: 'email_admin@example.com', sub: SecureRandom.uuid, admin: true)
  end
end

World(SignInHelper)
