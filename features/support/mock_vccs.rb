# frozen_string_literal: true

# helper methods for search vehicles flow
module MockVccs
  def mock_vehicle_details
    vehicle_details = read_response('vehicle_details.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end

  def mock_exempt_vehicle_details
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return('exempt' => true)
  end

  def mock_not_found_vehicle_details
    allow(ComplianceCheckerApi).to receive(:vehicle_details)
      .and_raise(BaseApi::Error404Exception.new(404, '', {}))
  end

  def mock_clean_air_zones(caz_list = nil)
    caz_list ||= read_response('caz_list.json')['cleanAirZones']
    stub = caz_list.map { |caz_data| CleanAirZone.new(caz_data) }.sort_by(&:name)
    allow(CleanAirZone).to receive(:all).and_return(stub)
  end

  def mock_one_clean_air_zones
    stub = [read_response('caz_list.json')['cleanAirZones'].first].map do |caz_data|
      CleanAirZone.new(caz_data)
    end.sort_by(&:name)
    allow(CleanAirZone).to receive(:all).and_return(stub)
  end
end

World(MockVccs)
