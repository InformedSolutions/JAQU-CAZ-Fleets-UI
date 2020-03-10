# frozen_string_literal: true

##
# Represents the virtual model of the vehicle.
#
class Vehicle
  # Initializer method.
  #
  # ==== Params
  # * +data+ - hash
  #    * +registrationNumber+ - string, vehicle registration number
  #    * +vehicleType+ - string, type of the vehicle
  #    * +complianceOutcomes+ - array of hashes
  #       * +cleanAirZoneId+ - UUID, ID of the CAZ
  #       * +charge+ - float, charge for given CAZ
  #       * +tariffCode+ - string, tariff that was used for calculations
  #
  def initialize(data)
    @data = data
  end

  # Returns vehicle's registration number
  def vrn
    data['registrationNumber']
  end

  # Returns vehicle's type
  def type
    (data['vehicleType'] || 'undetermined').humanize
  end

  # Returns the charge for given CAZ in float
  def charge(caz_id)
    compliance = data['complianceOutcomes'].find { |res| res['cleanAirZoneId'] == caz_id }
    return nil unless compliance

    compliance['charge'] == 'null' ? nil : compliance['charge'].to_f
  end

  # Returns the parsed charge for given CAZ eg. £12.50.
  # Returns 'Unknown' if the charge is undefined.
  # Returns 'No charge' if the charge equals zero
  def formatted_charge(caz_id)
    charge = charge(caz_id)
    return 'Undetermined' unless charge

    return 'No charge' if charge.zero?

    return "£#{charge.to_i}" if (charge % 1).zero?

    "£#{format('%<pay>.2f', pay: charge)}"
  end

  private

  # Reader for data hash
  attr_reader :data
end
