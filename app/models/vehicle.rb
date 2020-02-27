# frozen_string_literal: true

##
# Represents the virtual model of the vehicle.
#
class Vehicle
  # Initializer method.
  #
  # ==== Params
  # * +data+ - hash
  #    * +registrationNumber+ or +vrn+ - string, vehicle registration number
  #    * +vehicleType+ - string, type of the vehicle
  #    * +complianceOutcomes+ - array of hashes
  #       * +cleanAirZoneId+ - UUID, ID of the CAZ
  #       * +charge+ - float, charge for given CAZ
  #       * +tariffCode+ - string, tariff that was used for calculations
  #    * +paidDates+ - an array of dates that were already paid
  #
  def initialize(data)
    @data = data
  end

  # Returns vehicle's registration number
  def vrn
    data['registrationNumber'] || data['vrn']
  end

  # Returns vehicle's type
  def type
    (data['vehicleType'] || 'not found').humanize
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
    return 'N/A' unless charge

    return 'No charge' if charge.zero?

    return "£#{charge.to_i}" if (charge % 1).zero?

    "£#{format('%<pay>.2f', pay: charge)}"
  end

  # Returns an array of dates in '%Y-%m-%d' format
  def paid_dates
    data['paidDates'] || []
  end

  private

  # Reader for data hash
  attr_reader :data
end
