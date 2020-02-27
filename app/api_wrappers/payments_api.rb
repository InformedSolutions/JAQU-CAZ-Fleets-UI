# frozen_string_literal: true

##
# API wrapper for connecting to Payments API.
#
class PaymentsApi < BaseApi
  base_uri ENV.fetch('PAYMENTS_API_URL', 'localhost:3001') + '/v1'

  class << self
    ##
    # Calls +/v1/accounts/:account_id/charges+ endpoint with +GET+ method
    # and returns paginated list of the fleet vehicles with compliance results.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +zones+ - array of CleanAirZones IDs, default to empty array
    #
    # ==== Example
    #
    #    PaymentsApi.charges(account_id: '1f30838f-69ee-4486-95b4-7dfcd5c6c67c', page: 1)
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +vehicles+ - list of the vehicles
    # * +perPage+ - requested per_page value
    # * +page+ - requested page value
    # * +pageCount+ - number of available pages
    # * +totalVrnsCount+ - total number of vehicles in the fleet
    #
    # ==== Serialization
    #
    # {PaginatedFleet model}[rdoc-ref:PaginatedFleet]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def charges(account_id:, page:, per_page: 10, zones: [])
      log_action("Getting charges for page: #{page}")
      query = { 'pageNumber' => page - 1, 'pageSize' => per_page }
      query['zones'] = zones.join(',') if zones.any?
      request(:get, "/accounts/#{account_id}/charges", query: query)
    end

    ##
    # Calls +/v1/accounts/:account_id/charges+ endpoint with +GET+ method
    # and returns paginated list of the fleet vehicles with compliance results.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +page+ - requested page of the results
    # * +per_page+ - number of vehicles per page, defaults to 10
    # * +zones+ - array of CleanAirZones IDs, default to empty array
    # * +vrn+ - registration number used to mark page start/end
    # * +direction+ - indicates direction of traveling between pages (+next+ or +previous+)
    #
    # ==== Example
    #
    #    PaymentsApi.chargeable_vehicles(
    #       account_id: '1f30838f-69ee-4486-95b4-7dfcd5c6c67c',
    #       zone_id: 'be6010fa-4923-4e52-b2e1-94f27b14d158'
    #    )
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +chargeableAccountVehicles+ - list of the vehicles
    # * +firstVrn+ - VRN used to fetch the previous page
    # * +lastVrn+ - VRN used to fetch the next page
    #
    # ==== Serialization
    #
    # {ChargeableFleet model}[rdoc-ref:ChargeableFleet]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception] - invalid parameters
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def chargeable_vehicles(account_id:, zone_id:, vrn: nil, direction: nil)
      log_action('Getting chargeable vehicles')
      query = { 'cleanAirZoneId' => zone_id, 'pageSize' => 10 }
      if vrn.present? && direction.present?
        query['vrn'] = vrn
        query['direction'] = direction
      end
      request(:get, "/accounts/#{account_id}/chargeable-vehicles", query: query)
    end
  end
end
