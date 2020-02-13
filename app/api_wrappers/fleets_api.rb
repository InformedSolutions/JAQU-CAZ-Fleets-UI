# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi
  base_uri 'http://localhost:3001/v1'

  class << self
    ##
    # Calls +/v1/accounts/register-csv-from-s3/jobs+ endpoint with +POST+ method
    # and returns a job UUID
    #
    # ==== Attributes
    #
    # * +filename+ - Csv file name, eg. 'fleet_email@example.com_1579778166'
    # * +correlation_id+ - Correlation id, eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #
    # ==== Example
    #
    #    FleetsApi.register_job(
    #       filename: 'fleet_email@example.com_1579778166',
    #       correlation_id: '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #    )
    #
    # ==== Result
    #
    # Returns a UUID, eg. '2ad47f86-8365-47ee-863b-dae6dbf69b3e'.
    #
    def register_job(filename:, correlation_id:)
      log_action("Registering job with filename: #{filename}")
      request(
        :post,
        '/accounts/register-csv-from-s3/jobs',
        body: {
          'filename' => filename,
          's3Bucket' => ENV.fetch('S3_AWS_BUCKET', 'S3_AWS_BUCKET')
        }.to_json,
        headers: custom_headers(correlation_id)
      )['jobName']
    end

    ##
    # Calls +/v1/accounts/register-csv-from-s3/jobs/:job_name+ endpoint with +GET+ method
    # and returns a job status and job errors.
    #
    # ==== Attributes
    #
    # * +job_name+ - Job name returned in register_job call, eg '2ad47f86-8365-47ee-863b-dae6dbf69b3e'
    # * +correlation_id+ - Correlation id (same as in register_job call), eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #
    # ==== Example
    #
    #    FleetsApi.job_status(
    #       job_name: '2ad47f86-8365-47ee-863b-dae6dbf69b3e',
    #       correlation_id: '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #    )
    #
    # ==== Result
    #
    # Returns a hash
    # * success - { status: 'SUCCESS', errors: [] }
    # * failure - { status: 'FAILURE', errors: ['Invalid VRN'] }
    #
    def job_status(job_name:, correlation_id:)
      log_action("Getting job status with job name: #{job_name}")
      request(
        :get,
        "/accounts/register-csv-from-s3/jobs/#{job_name}",
        headers: custom_headers(correlation_id)
      ).symbolize_keys
    end

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
