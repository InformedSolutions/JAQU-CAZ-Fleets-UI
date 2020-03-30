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

                result.map { |mandate_data| Mandate.new(mandate_data) }
              end
  end

  # Returns an array of associated Mandate instances in `active` or `pending` statuses
  def active_mandates
    mandates.select do |mandate|
      select_active_statuses(mandate.status)
    end
  end

  # Returns an array of associated Mandate instances without `active` or `pending` statuses
  def inactive_mandates
    mandates.reject do |mandate|
      select_active_statuses(mandate.status)
    end
  end

  # Calls {rdoc-ref:DebitsApi.caz_mandates} to fetch data.
  # Selecting the mandates only in 'active' status
  #
  # ==== Params
  # * +account_id+ - ID of the account associated with the fleet
  # * +zone_id+ - uuid, ID of the CAZ
  #
  def caz_mandates(zone_id)
    @caz_mandates ||= DebitsApi.caz_mandates(
      account_id: account_id,
      zone_id: zone_id
    ).select { |mandate| select_active_status(mandate['status']) }
  end

  private

  # Reader for account id from backend DB
  attr_reader :account_id

  # Returns true if status 'active' or 'pending'
  def select_active_statuses(status)
    return false unless status

    status.downcase == 'active' || status.downcase == 'pending'
  end

  # Returns true if status 'active'
  def select_active_status(status)
    return false unless status

    status.downcase == 'active'
  end
end
