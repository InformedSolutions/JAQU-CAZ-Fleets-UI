# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi
  class << self
    #:nocov:
    def fleet_vehicles(account_id:, page:, per_page: 10)
      return [] unless $request

      log_action("Getting page #{page} of the fleet for account: #{account_id}")
      fleet = $request.session['mocked_fleet'] || []
      {
        'vehicles' => fleet.sort_by { |v| v['vrn'] }.paginate(per_page: 10, page: page),
        'perPage' => per_page,
        'page' => page,
        'pageCount' => (fleet.size / per_page.to_f).ceil,
        'totalVrnsCount' => fleet.size
      }
    end

    def add_vehicle_to_fleet(vrn:, _account_id:)
      return false unless $request

      log_action("Adding #{vrn} to the fleet")
      fleet = $request.session['mocked_fleet'] || []
      fleet.push(mocked_new_vehicle(details)) unless fleet.any? { |vehicle| vehicle['vrn'] == vrn }
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

      zone_ids = CleanAirZone.all.map(&:id)
      fleet = (1..(ENV['REDIS_URL'] ? 50 : 5)).map do |i|
        mocked_new_vehicle(
          { vrn: "CAS3#{Kernel.format('%<number>02d', number: i)}", type: 'car' }, zone_ids
        )
      end
      $request.session['mocked_fleet'] = fleet
      log_action("Current fleet: #{fleet}")
      true
    end

    private

    def mocked_new_vehicle(details, zone_ids = CleanAirZone.all.map(&:id))
      {
        'vrn' => details[:vrn],
        'vehicleType' => details[:type] || type(details[:vrn]),
        'complianceResults' => zone_ids.map do |id|
          { 'cleanAirZoneId' => id, 'charge' => [0, 8, 12.5, nil].sample }
        end
      }
    end

    def type(vrn)
      type = ComplianceCheckerApi.vehicle_details(vrn)['type']
      type == 'null' ? 'unknown' : type
    end
    #:nocov:
  end
end
