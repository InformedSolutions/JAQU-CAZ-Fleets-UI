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
  attr_accessor :email, :owner, :permissions, :user_id, :account_id, :account_name, :login_ip,
                :days_to_password_expiry

  # Delegates fleet methods to fleet
  delegate :vehicles, :add_vehicle, :remove_vehicle, :charges, :charges_by_vrn, to: :fleet

  # Delegates debit methods to payment_method
  delegate :mandates, to: :direct_debit

  # Overrides default initializer for compliance with Devise Gem.
  #
  # Set +owner+ to false by default
  def initialize(options = {})
    self.owner = false
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
  #   user #<User email: example@email.com, owner: false, ...>
  #   user.serializable_hash #{:email=>"example@email.com", :owner=>false, ...}
  def serializable_hash(_options = nil)
    {
      email: email,
      owner: owner,
      permissions: permissions,
      user_id: user_id,
      account_id: account_id,
      account_name: account_name,
      login_ip: login_ip,
      days_to_password_expiry: days_to_password_expiry
    }
  end

  # Returns associated fleet object
  def fleet
    @fleet ||= VehiclesManagement::Fleet.new(account_id)
  end

  # Serializes User based on data from API
  def self.serialize_from_api(user_attributes)
    User.new(
      email: user_attributes['email'],
      user_id: user_attributes['accountUserId'],
      account_id: user_attributes['accountId'],
      account_name: user_attributes['accountName'],
      owner: user_attributes['owner'],
      permissions: user_attributes['permissions'],
      days_to_password_expiry: calculate_days_to_password_expiry(user_attributes['passwordUpdateTimestamp'])
    )
  end

  # Checks if user password has expired
  # Returns boolean
  def force_password_update?
    days_to_password_expiry > 90
  end

  # Calculates days to password expiry
  # Returns number
  def self.calculate_days_to_password_expiry(date)
    return if date.nil?

    90 - (Date.current.mjd - Date.parse(date).mjd)
  end
end
