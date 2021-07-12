# frozen_string_literal: true

##
# Controller class for the static pages
#
class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_password_age
  before_action :disable_cookies, only: :relevant_portal_cookies

  ##
  # Renders the accessibility statement page
  #
  # ==== Path
  #    GET /accessibility_statement
  #
  def accessibility_statement
    # renders static page
  end

  ##
  # Renders the cookies page
  #
  # ==== Path
  #    GET /cookies
  #
  def cookies
    # renders static page
  end

  ##
  # Renders the support page
  #
  # ==== Path
  #    GET /relevant_portal_cookies
  #
  def relevant_portal_cookies
    # renders static page
  end

  ##
  # Renders the support page
  #
  # ==== Path
  #    GET /support
  #
  def support
    @zones = CleanAirZone.visible_cazes
  end

  ##
  # Renders the privacy notice page
  #
  # ==== Path
  #    GET /privacy_notice
  #
  def privacy_notice
    @zones = CleanAirZone.visible_cazes
  end

  ##
  # Renders the terms and conditions page
  #
  # ==== Path
  #    GET /terms_and_conditions
  #
  def terms_and_conditions
    # renders static page
  end

  private

  # Disable session cookies
  def disable_cookies
    request.session_options[:skip] = true
  end
end
