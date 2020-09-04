# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::LargeFleetThreshold do
  subject { described_class.call(file: file) }

  let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.csv') }
  let(:file) { fixture_file_upload(file_path) }

  describe '#call' do
    context 'when uploaded file is less than threshold' do
      it { expect(subject).to be_falsey }
    end

    context 'when uploaded file is not less than threshold' do
      before { Rails.configuration.x.large_fleet_threshold = 5 }

      it { expect(subject).to be_truthy }

      after { Rails.configuration.x.large_fleet_threshold = 100 }
    end
  end
end
