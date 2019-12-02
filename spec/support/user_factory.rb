# frozen_string_literal: true

module UserFactory
  def new_user(options = {})
    User.new(
      email: options[:email] || 'test@exaple.com',
      admin: options[:admin] || false,
      user_id: options[:user_id] || SecureRandom.uuid,
      account_id: options[:account_id] || SecureRandom.uuid,
      account_name: options[:account_name] || 'Royal Mail'
    )
  end
end
