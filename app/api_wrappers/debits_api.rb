# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding direct debits management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class DebitsApi < AccountsApi
  class << self
    #:nocov:
    def account_mandates(account_id:)
      log_action("Getting mandates for account with id: #{account_id}")
      return [] unless $request

      $request.session[session_key] || []
    end

    def add_mandate(zone_id:, account_id:)
      log_action("Adding a mandate for account with id: #{account_id} and zone id: #{zone_id}")
      return false unless $request

      mandates = $request.session[session_key] || []
      unless mandates.any? { |mandate| mandate['zoneId'] == zone_id }
        mandates.push(mocked_new_mandate(zone_id))
      end
      $request.session[session_key] = mandates
      true
    end

    private

    def session_key
      'mocked_fleet'
    end

    def mocked_new_mandate(zone_id)
      {
        'zoneId' => zone_id,
        'zoneName' => ComplianceCheckerApi.clean_air_zones.find do |zone|
          zone['cleanAirZoneId'] == zone_id
        end['name'] || 'no name',
        'mandateId' => SecureRandom.uuid,
        'status' => 'pending'
      }
    end
  end
end
