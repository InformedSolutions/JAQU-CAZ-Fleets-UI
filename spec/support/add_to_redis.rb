# frozen_string_literal: true

module AddToRedis
  def add_caz_lock_to_redis(user_id)
    REDIS.hmset(caz_lock_key,
                'account_id', user.account_id,
                'user_id', user_id,
                'caz_id', caz_id,
                'email', user.email)
  end
end
