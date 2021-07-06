# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  account
  account_id
  account_name
  authenticity_token
  confirmation
  email
  license_number
  login_ip
  name
  password
  plate_number
  token
  user_id
  vehicles
  vrm
  vrn
]
