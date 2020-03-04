# frozen_string_literal: true

##
# Controller class for the static pages
#
class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  # assign back button path
  before_action :assign_back_button_url, only: %i[cookies]

  ##
  # Renders the cookies page
  #
  # ==== Path
  #    GET /cookies
  #
  def cookies
    # renders static page
  end
end
