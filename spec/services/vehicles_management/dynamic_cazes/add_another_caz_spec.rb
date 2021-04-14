# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::AddAnotherCaz do
  subject { described_class.new(session: session).call }

  let(:selected_zones_in_sesssion) { session[:fleet_dynamic_zones] }
  let(:session) { { fleet_dynamic_zones: { SecureRandom.uuid => {} } } }

  before { subject }

  it 'sets new uuid in session' do
    expect(session[:fleet_dynamic_zones].count).to eq(2)
  end
end
