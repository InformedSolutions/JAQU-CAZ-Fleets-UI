# frozen_string_literal: true

module MockDebit
  def create_empty_debit
    create_debit(mandates: [], zones: mocked_zones)
  end

  def create_debit(mandates: mocked_mandates, zones: [])
    instance_double(DirectDebit,
                    mandates: mandates,
                    add_mandate: true,
                    zones_without_mandate: zones)
  end

  def mocked_mandates
    mandates_data = read_response('mandates.json')
    mandates_data.map { |data| Mandate.new(data) }
  end

  def mocked_zones
    caz_data = read_response('caz_list.json')['cleanAirZones']
    caz_data.map { |data| CleanAirZone.new(data) }
  end

  def mock_debit(debit_instance = create_debit)
    @debit = debit_instance
    allow(DirectDebit).to receive(:new).and_return(@debit)
  end
end

World(MockDebit)
