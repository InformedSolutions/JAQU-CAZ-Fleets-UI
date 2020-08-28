# frozen_string_literal: true

Redis.new(cluster: [ENV['REDIS_URL']]) if Rails.env.production? && ENV['REDIS_URL']
