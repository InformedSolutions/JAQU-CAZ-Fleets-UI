# frozen_string_literal: true

REDIS = if Rails.env.production? && ENV['REDIS_URL']
          # :nocov:
          Redis.new(cluster: [ENV['REDIS_URL']])
          # :nocov:
        else
          Redis.new
        end
