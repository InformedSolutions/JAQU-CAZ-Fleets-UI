# frozen_string_literal: true

module UserFactory
  def create_admin(options = {})
    create_user(options.merge(admin: true))
  end

  def create_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      admin: options[:admin] || false,
      **account_data(options),
      login_ip: options[:login_ip] || @remote_ip
    )
  end

  private

  def account_data(options)
    {
      user_id: options[:user_id] || SecureRandom.uuid,
      account_id: options[:account_id] || SecureRandom.uuid,
      account_name: options[:account_name] || 'Royal Mail'
    }
  end
end
