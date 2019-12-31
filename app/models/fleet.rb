# frozen_string_literal: true

##
# Represents the virtual model of the fleet.
#
class Fleet
  # Initializer method.
  #
  # ==== Params
  # * +account_id+ - Account ID from backend DB
  #
  def initialize(account_id)
    @account_id = account_id
  end

  # Returns an array of Vehicle instances associated with the account.
  def vehicles
    @vehicles ||= begin
                 data = FleetsApi.fleet_vehicles(_account_id: account_id)
                 data.map { |vehicle_data| Vehicle.new(vehicle_data) }
               end
  end

  # Adds a new vehicle to fleet.
  #
  # ==== Params
  # * +vehicle_details+ - hash
  #    * +vrn+ - string, vehicle registration number, required
  #    * +type+ - string, type of the vehicle, optional
  #    * +leeds_charge+ - float, charge in Leeds, optional
  #    * +birmingham_charge+ - float, charge in Birmingham, optional
  def add_vehicle(vehicle_details)
    FleetsApi.add_vehicle_to_fleet(details: vehicle_details, _account_id: account_id)
  end

  private

  # Reader for Account ID from backend DB
  attr_reader :account_id
end
