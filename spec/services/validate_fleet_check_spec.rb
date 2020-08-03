# frozen_string_literal: true

require 'rails_helper'

describe ValidateFleetCheck do
  subject(:service) { described_class.call(confirm_fleet_check: confirm_fleet_check) }

  let(:confirm_fleet_check) { 'two_or_more' }
  let(:valid) { true }
  let(:errors) { [] }

  context 'when valid params' do
    before do
      allow(FleetCheckForm)
        .to receive(:new)
        .and_return(instance_double(FleetCheckForm, valid?: valid))
    end

    it 'calls FleetCheckForm with proper params' do
      expect(FleetCheckForm).to receive(:new).with(confirm_fleet_check: confirm_fleet_check)
      service
    end
  end

  context 'when invalid params' do
    let(:valid) { false }
    let(:errors) { ActiveModel::Errors.new(['Some error']) }

    before do
      allow(FleetCheckForm)
        .to receive(:new)
        .and_return(instance_double(FleetCheckForm, valid?: valid, errors: errors))
    end

    context 'when confirm_fleet_check is invalid' do
      it 'raises `InvalidFleetCheckException` exception with proper errors object' do
        expect { service }.to raise_error(
          InvalidFleetCheckException
        )
      end
    end
  end

  context 'when confirm_fleet_check is `less_than_two`' do
    let(:confirm_fleet_check) { 'less_than_two' }

    it 'raises `InvalidFleetCheckException` exception' do
      expect { service }.to raise_error(
        AccountForMultipleVehiclesException
      )
    end
  end
end
