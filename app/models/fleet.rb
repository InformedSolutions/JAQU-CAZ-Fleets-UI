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

  # Returns a PaginatedFleet with vehicles associated with the account.
  # Includes data about page and total pages count.
  def pagination(page:)
    @pagination ||= begin
                 data = PaymentsApi.charges(account_id: account_id, page: page)
                 PaginatedFleet.new(data)
               end
  end

  # Adds a new vehicle to the fleet.
  #
  # ==== Params
  # * +vrn+ - string, vehicle registration number, required
  #
  def add_vehicle(vrn)
    FleetsApi.add_vehicle_to_fleet(vrn: vrn, account_id: account_id)
  end

  # Removes a vehicle from the fleet.
  #
  # ==== Params
  # * +vrn+ - string, vehicle registration number, required
  #
  def delete_vehicle(vrn)
    FleetsApi.remove_vehicle_from_fleet(vrn: vrn, account_id: account_id)
  end

  # Checks if there are any vehicles in the fleet. Returns boolean.
  def empty?
    FleetsApi.fleet_vehicles(account_id: account_id, page: 1, per_page: 1)['vrns'].empty?
  end

  private

  # Reader for Account ID from backend DB
  attr_reader :account_id
end
