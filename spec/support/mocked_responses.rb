# frozen_string_literal: true

module MockedResponses
  def mock_caz_list(caz_list = nil)
    caz_list ||= read_response('caz_list.json')['cleanAirZones']
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
  end

  def mock_debits(mocked_file = 'mandates')
    api_response = read_response("/debits/#{mocked_file}.json")['clearAirZones']
    allow(DebitsApi).to receive(:mandates).and_return(api_response)
  end
end
