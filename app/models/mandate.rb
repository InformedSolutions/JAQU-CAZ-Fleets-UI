# frozen_string_literal: true

##
# Class used to serialize data from DebitsApi.mandates
#
class Mandate
  # Initializer method. Assigns :data
  #
  # ==== Params
  #
  # * +cazId+ - uuid, CleanAirZone ID
  # * +cazName+ - string, name of the CAZ
  # * +mandates+ - hash
  #   * +id+ - uuid, mandate ID
  #   * +status+ - string, status of the mandate eg. 'active'
  #
  def initialize(data)
    @data = data
  end

  # Returns the ID of associated CAZ
  def zone_id
    data['cazId']
  end

  # Returns the name of associated CAZ
  def zone_name
    data['cazName']&.humanize
  end

  # Returns mandate's ID
  def id
    return nil if data['mandates'].empty?

    data.dig('mandates', 'id')
  end

  # Returns mandate status
  def status
    return nil if data['mandates'].empty?

    data.dig('mandates', 'status')&.humanize
  end

  private

  # Reader for data hash
  attr_reader :data
end
