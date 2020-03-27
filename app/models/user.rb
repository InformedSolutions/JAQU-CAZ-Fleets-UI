# frozen_string_literal: true

##
# This class is used to authorize a user account and to sign uploaded CSV documents.
class User
  # required by Devise
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend Devise::Models

  # Allows to use validation callbacks.
  define_model_callbacks :validation
  # Allow remote authentication with devise.
  devise :remote_authenticatable
  # Takes care of verifying whether a user session has already expired or not.
  devise :timeoutable

  # User attributes
  attr_accessor :email, :admin, :user_id, :account_id, :account_name, :login_ip

  # Delegates fleet methods to fleet
  delegate :vehicles, :add_vehicle, :remove_vehicle, :charges, :charges_by_vrn, to: :fleet

  # Delegates debit methods to payment_method
  delegate :mandates, :add_mandate, :zones_without_mandate, to: :direct_debit

  # Overrides default initializer for compliance with Devise Gem.
  #
  # Set +admin+ to false by default
  def initialize(options = {})
    self.admin = false
    options.each do |key, value|
      public_send("#{key}=", value) if respond_to?(key)
    end
  end

  # Used in devise and should return nil when the object is not persisted.
  def to_key
    nil
  end

  # Returns a serialized hash of your object.
  #
  # ==== Example
  #   user = User.new()email = 'example@email.com'
  #   user #<User email: example@email.com, admin: false, ...>
  #   user.serializable_hash #{:email=>"example@email.com", :admin=>false, ...}
  def serializable_hash(_options = nil)
    {
      email: email,
      admin: admin,
      user_id: user_id,
      account_id: account_id,
      account_name: account_name,
      login_ip: login_ip
    }
  end

  # Returns associated fleet object
  def fleet
    @fleet ||= Fleet.new(account_id)
  end

  # Serializes User based on data from API
  def self.serialize_from_api(user_attributes)
    User.new(
      email: user_attributes['email'],
      user_id: user_attributes['accountUserId'],
      account_id: user_attributes['accountId'],
      account_name: user_attributes['accountName'],
      admin: user_attributes['admin']
    )
  end
end
