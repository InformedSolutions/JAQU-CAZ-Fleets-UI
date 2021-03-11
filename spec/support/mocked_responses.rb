# frozen_string_literal: true

module MockedResponses
  def mock_debits(mocked_file = 'mandates')
    api_response = read_response("debits/#{mocked_file}.json")['cleanAirZones']
    allow(DebitsApi).to receive(:mandates).and_return(api_response)
  end

  def mock_caz_mandates(mocked_file = 'caz_mandates')
    api_response = read_response("debits/#{mocked_file}.json")['mandates']
    allow(DebitsApi).to receive(:caz_mandates).and_return(api_response)
  end

  def mock_clean_air_zones
    caz_list ||= read_response('caz_list.json')['cleanAirZones']
    stub = caz_list.map { |caz_data| CleanAirZone.new(caz_data) }.sort_by(&:name)
    allow(CleanAirZone).to receive(:all).and_return(stub)
  end

  def mock_direct_debit_enabled
    allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
    allow(Rails.application.config.x).to(
      receive(:method_missing).with(:feature_direct_debits).and_return('true')
    )
  end

  def mock_direct_debit_disabled
    allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
    allow(Rails.application.config.x).to(
      receive(:method_missing).with(:feature_direct_debits).and_return('false')
    )
  end
end
