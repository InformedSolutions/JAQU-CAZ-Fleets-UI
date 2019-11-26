# frozen_string_literal: true

class SignInController < ApplicationController
  def new; end

  def create
    redirect_to company_dashboard_path
  end
end
