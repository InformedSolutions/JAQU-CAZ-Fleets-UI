# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetFleetCheck do
  subject(:service) do
    described_class.call(session: session, params: { confirm_fleet_check: confirm_fleet_check })
  end

  let(:session) { { confirm_fleet_check: {} } }
  let(:confirm_fleet_check) { 'Test company' }

  it 'sets new_account confirm_fleet_check' do
    service
    expect(session[:new_account][:confirm_fleet_check]).to eq(confirm_fleet_check)
  end
end
