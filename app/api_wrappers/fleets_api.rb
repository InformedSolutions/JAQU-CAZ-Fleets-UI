# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi
  class << self
    def fleet_vehicles(_account_id:)
      return [] unless $request

      $request.session['mocked_fleet'] || []
    end

    def add_vehicle_to_fleet(details:, _account_id:)
      return false unless $request

      fleet = $request.session['mocked_fleet'] || []
      unless fleet.any? { |vehicle| vehicle['vrn'] == details[:vrn] }
        fleet.push(mocked_new_vehicle(details))
      end
      $request.session['mocked_fleet'] = fleet
      true
    end

    private

    def mocked_new_vehicle(details)
      {
        'vehicleId' => SecureRandom.uuid,
        'vrn' => details[:vrn],
        'type' => ComplianceCheckerApi.vehicle_details(details[:vrn])['type'],
        'charges' => {
          'leeds' => details[:leeds_charge] || 12.5,
          'birmingham' => details[:birmingham_charge] || 8
        }
      }
    end
  end
end
