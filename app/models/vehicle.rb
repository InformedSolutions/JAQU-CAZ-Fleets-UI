# frozen_string_literal: true

##
# Represents the virtual model of the vehicle.
#
class Vehicle
  # Initializer method.
  #
  # ==== Params
  # * +data+ - hash
  #    * +vehcileId+ - UUID, ID of the vehicle
  #    * +vrn+ - string, vehicle registration number
  #    * +type+ - string, type of the vehicle
  #    * +charges+ - hash
  #       * +leeds+ - float, charge for Leeds
  #       * +birmingham+ - float, charge for Birmingham
  #
  def initialize(data)
    @data = data
  end

  # Returns vehicle's ID
  def id
    data['vehicleId']
  end

  # Returns vehicle's registration number
  def vrn
    data['vrn']
  end

  # Returns vehicle's type
  def type
    (data['type'] || 'unrecognised').humanize
  end

  # Returns the charge for given CAZ in float
  def charge(caz)
    (data['charges'][caz.downcase] || 0).to_f
  end

  # Returns the parsed charge for given CAZ eg. £12.50
  def formatted_charge(caz)
    charge = charge(caz)
    return 'No charge' if charge.zero?

    "£#{format('%<pay>.2f', pay: charge)}"
  end

  private

  # Reader for data hash
  attr_reader :data
end
