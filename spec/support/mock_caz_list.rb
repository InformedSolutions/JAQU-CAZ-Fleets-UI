# frozen_string_literal: true

module MockCazList
  def mock_caz_list(caz_list = nil)
    caz_list ||= read_response('caz_list.json')['cleanAirZones']
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
  end
end
