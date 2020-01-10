# frozen_string_literal: true

##
# Serializes DirectDebit functionality. Used to manage mandates.
#
class DirectDebit
  # Initializer method.
  #
  # ==== Params
  # * +account_id+ - Account ID from backend DB
  #
  def initialize(account_id)
    @account_id = account_id
  end

  # Returns an array of associated Mandate instances.
  # It calls DebitsApi.account_mandates to fetch data.
  #
  def mandates
    @mandates ||= begin
                    data = DebitsApi.account_mandates(account_id: account_id)
                    data.map { |mandate_data| Mandate.new(mandate_data) }
                  end
  end

  # Adds a new mandate to the account.
  #
  # ==== Params
  # * +zone_id+ - uuid, ID of the CAZ
  #
  def add_mandate(zone_id)
    DebitsApi.add_mandate(zone_id: zone_id, account_id: account_id)
  end

  # Returns an array of CleanAirZone instances
  # which are not used currently for any mandate.
  #
  # It calls ComplianceCheckerApi.clean_air_zones and DebitsApi.account_mandates
  #
  def zones_without_mandate
    zones = CleanAirZone.all
    zones.reject { |zone| zone.id.in?(mandates.map(&:zone_id)) }
  end

  private

  # Reader for Account ID from backend DB
  attr_reader :account_id
end
