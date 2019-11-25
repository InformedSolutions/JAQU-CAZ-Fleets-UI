# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # protects applications against CSRF
  protect_from_forgery prepend: true
end
