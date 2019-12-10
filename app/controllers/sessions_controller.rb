# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  ##
  # Renders the sign out page
  #
  # ==== Path
  #
  #    :GET /sign-out
  #
  def sign_out
    render 'devise/sessions/sign_out'
  end
end
