# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::DynamicCazes::AddAnotherCaz do
  subject { described_class.new(session: session).call }

  let(:selected_zones_in_sesssion) { session[:selected_zones_ids] }
  let(:session) { { selected_zones_ids: [SecureRandom.uuid] } }

  before { subject }

  it 'sets new uuid in session' do
    expect(session[:selected_zones_ids].count).to eq(2)
  end
end
