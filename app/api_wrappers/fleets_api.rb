# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi
  class << self
    #:nocov:
    def fleet_vehicles(_account_id:)
      return [] unless $request

      log_action('Getting the fleet')
      fleet = $request.session['mocked_fleet'] || []
      log_action("Current fleet: #{fleet}")
      fleet
    end

    def add_vehicle_to_fleet(details:, _account_id:)
      return false unless $request

      log_action("Adding #{details[:vrn]} to the fleet")
      fleet = $request.session['mocked_fleet'] || []
      unless fleet.any? { |vehicle| vehicle['vrn'] == details[:vrn] }
        fleet.push(mocked_new_vehicle(details))
      end
      $request.session['mocked_fleet'] = fleet
      log_action("Current fleet: #{fleet}")
      true
    end

    def remove_vehicle_from_fleet(vrn:, _account_id:)
      return false unless $request

      log_action("Removing #{vrn} from the fleet")
      fleet = $request.session['mocked_fleet'] || []
      fleet.filter! { |vehicle| vehicle['vrn'] != vrn }
      $request.session['mocked_fleet'] = fleet
      log_action("Current fleet: #{fleet}")
      true
    end

    def mock_upload_fleet
      return false unless $request

      fleet = (1..5).map do |i|
        mocked_new_vehicle(vrn: "CAS30#{i}", type: 'car')
      end
      $request.session['mocked_fleet'] = fleet
      log_action("Current fleet: #{fleet}")
      true
    end

    private

    def mocked_new_vehicle(details)
      {
        'vehicleId' => SecureRandom.uuid,
        'vrn' => details[:vrn],
        'type' => details[:type] || ComplianceCheckerApi.vehicle_details(details[:vrn])['type'],
        'charges' => {
          'leeds' => details[:leeds_charge] || 12.5,
          'birmingham' => details[:birmingham_charge] || 8
        }
      }
    end
    #:nocov:
  end
end
