# frozen_string_literal: true

module UsersFactory
  def make_payments_user
    create_user({ permissions: ['MAKE_PAYMENTS'] })
  end

  def manage_mandates_user
    create_user({ permissions: ['MANAGE_MANDATES'] })
  end

  def manage_users_user(options = {})
    create_user(options.merge({ permissions: ['MANAGE_USERS'] }))
  end

  def manage_vehicles_user(options = {})
    create_user(options.merge({ permissions: ['MANAGE_VEHICLES'] }))
  end

  def view_payment_history_user(options = {})
    create_user(options.merge({ permissions: ['VIEW_PAYMENTS'] }))
  end

  def create_owner(options = {})
    create_user(options.merge(owner: true))
  end

  def create_user(options = {})
    User.new(
      email: options[:email] || 'test@example.com',
      owner: options[:owner] || false,
      **account_data(options),
      login_ip: options[:login_ip] || @remote_ip
    )
  end

  private

  def account_data(options)
    {
      user_id: options[:user_id] || SecureRandom.uuid,
      account_id: options[:account_id] || SecureRandom.uuid,
      account_name: options[:account_name] || 'Royal Mail',
      permissions: options[:permissions] || account_permissions,
      password_update_timestamp: options[:password_update_timestamp] || Date.current.to_s
    }
  end

  def account_permissions
    %w[MAKE_PAYMENTS MANAGE_MANDATES MANAGE_VEHICLES MANAGE_USERS]
  end
end
