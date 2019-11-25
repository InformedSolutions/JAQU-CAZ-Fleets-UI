class EmailsController < ApplicationController
  def new; end

  def create
    redirect_to company_password_path
  end
end
