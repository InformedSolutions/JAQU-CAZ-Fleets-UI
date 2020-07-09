# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::PaginatedFleet, type: :model do
  subject(:fleet) { described_class.new(data) }

  let(:size) { 51 }
  let(:page) { 3 }
  let(:per_page) { 10 }
  let(:vehicles_data) { read_response('fleet.json')['1'] }

  let(:data) do
    {
      'vehicles' => vehicles_data,
      'perPage' => per_page,
      'page' => page - 1,
      'pageCount' => (size / per_page.to_f).ceil,
      'totalVrnsCount' => size
    }
  end

  describe '.page' do
    it 'returns page value' do
      expect(fleet.page).to eq(page)
    end
  end

  describe '.total_pages' do
    it 'returns pageCount value' do
      expect(fleet.total_pages).to eq(data['pageCount'])
    end
  end

  describe '.total_vehicles_count' do
    it 'returns size value' do
      expect(fleet.total_vehicles_count).to eq(size)
    end
  end

  describe '.per_page' do
    it 'returns per_page value' do
      expect(fleet.per_page).to eq(per_page)
    end
  end

  describe '.range_start' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(fleet.range_start).to eq(1)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(fleet.range_start).to eq(21)
      end
    end
  end

  describe '.range_end' do
    context 'when on the first page' do
      let(:page) { 1 }

      it 'returns 1' do
        expect(fleet.range_end).to eq(per_page)
      end
    end

    context 'when on the other page' do
      it 'returns correct value' do
        expect(fleet.range_end).to eq(30)
      end
    end

    context 'when on the last page' do
      let(:page) { 6 }

      it 'returns size' do
        expect(fleet.range_end).to eq(size)
      end
    end
  end
end
