# frozen_string_literal: true

##
# Module used for make payments flow
module Payments
  ##
  # Represents the virtual model of the chargeable vehicles on matrix page.
  #
  class ChargeableVehicles
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    # * +zone_id+ - UUID, ID of the selected CAZ
    #
    def initialize(account_id, zone_id)
      @account_id = account_id
      @zone_id = zone_id
    end

    # Returns a Payments::PaginatedVehicles with chargeable vehicles associated with the account.
    # Includes data about page and total pages count.
    def pagination(page: 1, per_page: 10, only_chargeable: false, vrn: nil) # rubocop:disable Metrics/MethodLength
      @pagination ||= begin
        data = PaymentsApi.chargeable_vehicles(
          account_id: account_id,
          zone_id: zone_id,
          page: page,
          per_page: per_page,
          only_chargeable: only_chargeable,
          vrn: vrn
        )
        Payments::PaginatedVehicles.new(data, page, per_page)
      end
    end

    private

    # Attributes reader
    attr_reader :account_id, :zone_id
  end
end
