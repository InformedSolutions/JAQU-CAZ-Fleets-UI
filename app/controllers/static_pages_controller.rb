# frozen_string_literal: true

##
# Controller class for the static pages
#
class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_password_age

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
  # Renders the privacy notice page
  #
  # ==== Path
  #    GET /privacy_notice
  #
  def privacy_notice
    # renders static page
  end
end
