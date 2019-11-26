# frozen_string_literal: true

class OrganisationAccountsController < ApplicationController
  def new; end

  def create
    redirect_to company_email_address_path
  end

  def show; end
end
