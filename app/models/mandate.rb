# frozen_string_literal: true

##
# Class used to serialize data from DebitsApi.account_mandates
#
class Mandate
  # Initializer method. Assigns :data
  #
  # ==== Params
  #
  # * +zoneId+ - uuid, CleanAirZone ID
  # * +zoneName+ - string, name of the CAZ
  # * +mandateId+ - uuid, mandate ID
  # * +status+ = string, status of the mandate eg. 'pending'
  #
  def initialize(data)
    @data = data
  end

  # Returns mandate's ID
  def id
    data['mandateId']
  end

  # Returns debit status
  def status
    data['status'].humanize
  end

  # Returns the name od associated CAZ
  def zone_name
    data['zoneName'].humanize
  end

  # Returns the ID od associated CAZ
  def zone_id
    data['zoneId']
  end

  private

  # Reader for data hash
  attr_reader :data
end
