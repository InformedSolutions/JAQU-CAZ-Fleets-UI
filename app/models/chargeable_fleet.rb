# frozen_string_literal: true

##
# Class used to serialize data from PaymentsApi.chargeable_vehicles
#
class ChargeableFleet
  # Take data returned from the PaymentsApi.chargeable_vehicles
  def initialize(data)
    @data = data
  end

  # Returns an array of Vehicle model instances
  def vehicle_list
    @vehicle_list ||= (data.dig('chargeableAccountVehicles', 'results') || [])
                      .map { |vehicle_data| ChargeableVehicle.new(vehicle_data) }
  end

  # Checks if the previous page is available
  def previous_page?
    first_vrn.present?
  end

  # Checks if the next page is available
  def next_page?
    last_vrn.present?
  end

  # Returns VRN used to fetch the previous page
  def first_vrn
    data['firstVrn']
  end

  # Returns VRN used to fetch the next page
  def last_vrn
    data['lastVrn']
  end

  private

  attr_reader :data
end
