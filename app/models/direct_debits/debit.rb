# frozen_string_literal: true

##
# Module used for Direct Debits flow
module DirectDebits
  ##
  # Serializes DirectDebit functionality. Used to manage mandates.
  #
  class Debit
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    #
    def initialize(account_id)
      @account_id = account_id
    end

    # It calls {rdoc-ref:DebitsApi.mandates} to fetch data.
    # Modify `api_response` hash to keep a mandate only in `active` or `pending` status
    def mandates
      @mandates ||= begin
                  api_response = DebitsApi.mandates(account_id: account_id)
                  result = api_response.each do |obj|
                    active = obj['mandates'].find do |mandate|
                      select_active_statuses(mandate['status'])
                    end

                    obj['mandates'] = (active || [])
                  end

                  result.map { |mandate_data| DirectDebits::Mandate.new(mandate_data) }.sort_by(&:zone_name)
                end
    end

    # Returns an array of associated DirectDebits::Mandate instances in `active` or `pending` statuses
    def active_mandates
      mandates.select do |mandate|
        select_active_statuses(mandate.status)
      end
    end

    # Returns an array of associated DirectDebits::Mandate instances without `active` or `pending` statuses
    def inactive_mandates
      mandates.reject do |mandate|
        select_active_statuses(mandate.status)
      end
    end

    # Calls {rdoc-ref:DebitsApi.caz_mandates} to fetch data.
    # Find the mandate in 'active' or `pending` status
    #
    # ==== Params
    # * +account_id+ - ID of the account associated with the fleet
    # * +zone_id+ - uuid, ID of the CAZ
    #
    def caz_mandates(zone_id)
      @caz_mandates ||= begin
                          api_response ||= DebitsApi.caz_mandates(
                            account_id: account_id,
                            zone_id: zone_id
                          )
                          api_response&.find { |mandate| select_active_statuses(mandate['status']) }
                        end
    end

    private

    # Reader for account id from backend DB
    attr_reader :account_id

    # Returns true if status 'active' or 'pending'
    def select_active_statuses(status)
      return false unless status

      status.downcase == 'active' || status.downcase == 'pending'
    end
  end
end
