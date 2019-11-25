# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: '_caz-fleets_session',
                                       same_site: :strict
                                       # secure: Rails.env.production?
