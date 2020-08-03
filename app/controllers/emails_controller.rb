# frozen_string_literal: true

class EmailsController < ApplicationController
  def new
    # renders static page
  end

  def create
    redirect_to company_password_path
  end
end
