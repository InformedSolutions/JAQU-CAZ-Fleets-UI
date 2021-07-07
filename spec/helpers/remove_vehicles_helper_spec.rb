# frozen_string_literal: true

require 'rails_helper'

describe RemoveVehiclesHelper do
  before { session['remove_vehicles_list'] = %w[CAS123 CAS124] }

  describe '.remove_vrn_checked?' do
    subject { helper.remove_vrn_checked?(vrn) }

    context 'when vrn is present on the list' do
      let(:vrn) { 'CAS123' }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when vrn is not present on the list' do
      let(:vrn) { 'invalid' }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '.selected_vrns_count' do
    subject { helper.selected_vrns_count }

    it 'returns quantity of selected vrns' do
      expect(subject).to eq(2)
    end
  end

  describe '.remove_vehicles_list' do
    subject { helper.remove_vehicles_list }

    it 'returns a list of checked vrns' do
      expect(subject).to eq(%w[CAS123 CAS124])
    end
  end
end
