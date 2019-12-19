# frozen_string_literal: true

module MockFleet
  def mock_empty_fleet
    allow(Fleet).to receive(:new).and_return(instance_double(Fleet, vehicles: []))
  end
end

World(MockFleet)
