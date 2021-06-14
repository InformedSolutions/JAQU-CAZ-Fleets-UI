# frozen_string_literal: true

store_type = ENV['REDIS_URL'] && !Rails.env.test? ? :cache_store : :cookie_store
Rails.application.config.session_store store_type,
                                       key: '_caz_fleets_session',
                                       same_site: :lax,
                                       secure: Rails.env.production?
