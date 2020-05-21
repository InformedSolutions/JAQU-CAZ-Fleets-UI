# frozen_string_literal: true

##
# This class represents data returned by {CAZ API endpoint}[rdoc-ref:ComplianceCheckerApi.clean_air_zones]
#
class CleanAirZone
  ##
  # Creates an instance of a form class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +data+ - hash
  #   * +name+ - string, eg. 'Birmingham'
  #   * +clean_air_zone_id+ - UUID
  #   * +boundary_url+ - string, eg. 'www.example.com'
  def initialize(data)
    @caz_data = data.transform_keys { |key| key.underscore.to_sym }
  end

  # Represents CAZ ID in the backend API database.
  def id
    caz_data[:clean_air_zone_id]
  end

  # Returns a string, eg. 'Birmingham'.
  def name
    caz_data[:name]
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data[:boundary_url]
  end

  # Returns a string, eg. 'www.example.com'.
  def exemption_url
    caz_data[:exemption_url]
  end

  # Returns date when CAZ started charging, eg. '2020-05-01'
  def active_charge_start_date
    Date.parse(caz_data[:active_charge_start_date])
  end

  # Checks if zones was already checked by user before.
  # Returns a boolean.
  def checked?(checked_zones)
    checked_zones.include?(id)
  end

  # Fetches all available CAZs from ComplianceCheckerApi.clean_air_zones endpoint
  def self.all
    @all ||= ComplianceCheckerApi.clean_air_zones
                                 .map { |caz_data| new(caz_data) }
                                 .sort_by(&:name)
  end

  # Finds a zone by given ID
  def self.find(id)
    all.find { |caz| caz.id == id }
  end

  private

  attr_reader :caz_data
end
