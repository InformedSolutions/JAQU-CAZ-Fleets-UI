# frozen_string_literal: true

##
# Class used to display fleet on the manage vehicles page
#
class PaginatedFleet
  # Take data returned from the FleetsApi.fleet_vehicles
  def initialize(data)
    @data = data
  end

  # Returns an array of Vehicle model instances
  def vehicle_list
    @vehicle_list ||= data['vehicles'].map { |vehicle_data| Vehicle.new(vehicle_data) }
  end

  # Returns current page value
  def page
    data['page'] + 1
  end

  # Returns the number of available pages
  def total_pages
    data['pageCount']
  end

  # Returns the total number of vehicles in the fleet
  def total_vehicles_count
    data['totalVrnsCount']
  end

  # Returns the number of vehicles displayed per page
  def per_page
    data['perPage']
  end

  # Returns the index of the first vehicle on the page
  def range_start
    page * per_page - (per_page - 1)
  end

  # Returns the index of the last vehicle on the page
  def range_end
    max = page * per_page
    max > total_vehicles_count ? total_vehicles_count : max
  end

  private

  attr_reader :data
end
