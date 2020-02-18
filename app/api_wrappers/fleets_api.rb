# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding fleet management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class FleetsApi < AccountsApi
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
      log_action('Registering a new upload job')
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

    ##
    # Calls +/v1/accounts/:account_id/vehicles+ endpoint with +GET+ method
    # and returns paginated list of the fleet vehicles.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    #
    # ==== Example
    #
    #    FleetApi.fleet_vehicles(account_id: '1f30838f-69ee-4486-95b4-7dfcd5c6c67c', page: 1)
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +vrns+ - list of the vehicles' registration numbers
    # * +pageCount+ - number of available pages
    # * +totalVrnsCount+ - total number of vehicles in the fleet
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def fleet_vehicles(account_id:, page:, per_page: 10)
      log_action("Getting vehicles for page: #{page}")
      query = { 'pageNumber' => page - 1, 'pageSize' => per_page }
      request(:get, "/accounts/#{account_id}/vehicles", query: query)
    end

    #:nocov:
    def add_vehicle_to_fleet(vrn:, _account_id:)
      return false unless $request

      log_action("Adding #{vrn} to the fleet")
      fleet = $request.session['mocked_fleet'] || []
      unless fleet.any? { |vehicle| vehicle['vrn'] == vrn }
        fleet.push(mocked_new_vehicle(vrn: vrn))
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
