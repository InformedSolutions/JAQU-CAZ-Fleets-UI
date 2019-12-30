# frozen_string_literal: true

module MockVccs
  def mock_vehicle_details
    vehicle_details = read_response('vehicle_details.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .and_return(vehicle_details)
  end

  def mock_exempt_vehicle_details
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .and_return('exempt' => true)
  end

  def mock_not_found_vehicle_details
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .and_raise(BaseApi::Error404Exception.new(404, '', {}))
  end
end

World(MockVccs)
