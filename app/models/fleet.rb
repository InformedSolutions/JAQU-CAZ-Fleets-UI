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

  # Returns an OpenStruct with the paginated list of vehicles associated with the account.
  # Includes data about page and total pages count.
  def paginated_vehicles(page:)
    @paginated_vehicles ||= begin
                 data = FleetsApi.fleet_vehicles(account_id: account_id, page: page)
                 OpenStruct.new(
                   vehicle_list: vehicle_list(data),
                   page: data['page'],
                   total_pages: data['pageCount']
                 )
               end
  end

  # Adds a new vehicle to the fleet.
  #
  # ==== Params
  # * +vrn+ - string, vehicle registration number, required
  #
  def add_vehicle(vrn)
    FleetsApi.add_vehicle_to_fleet(vrn: vrn, _account_id: account_id)
  end

  # Removes a vehicle from the fleet.
  #
  # ==== Params
  # * +vrn+ - string, vehicle registration number, required
  #
  def delete_vehicle(vrn)
    FleetsApi.remove_vehicle_from_fleet(vrn: vrn, _account_id: account_id)
  end

  # Checks if there are any vehicles in the fleet. Returns boolean.
  def empty?
    FleetsApi.fleet_vehicles(account_id: account_id, page: 1, per_page: 1)['vehicles'].empty?
  end

  private

  # Reader for Account ID from backend DB
  attr_reader :account_id

  # Transforms data from fleet endpoint into an array of Vehicle instances
  def vehicle_list(data)
    data['vehicles'].map { |vehicle_data| Vehicle.new(vehicle_data) }
  end
end
