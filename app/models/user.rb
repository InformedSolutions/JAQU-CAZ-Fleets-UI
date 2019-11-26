# frozen_string_literal: true

class User
  # required by Devise
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend Devise::Models

  # Allows to use validation callbacks.
  define_model_callbacks :validation

  # Attribute that is being used to authorize a user
  attr_accessor :email, :password, :password_confirmation

  # Overrides default initializer for compliance with Devise Gem.
  def initialize(options = {}); end

  # Used in devise and should return nil when the object is not persisted.
  def to_key
    nil
  end
end
