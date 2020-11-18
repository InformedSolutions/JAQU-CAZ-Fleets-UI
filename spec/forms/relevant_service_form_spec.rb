# frozen_string_literal: true

require 'rails_helper'

describe RelevantServiceForm, type: :model do
  subject { described_class.new(check_vehicle_option) }

  let(:check_vehicle_option) { 'single' }

  it { is_expected.to be_valid }

  context 'when check_vehicle_option is empty' do
    let(:check_vehicle_option) { '' }

    it { is_expected.not_to be_valid }

    before do
      subject.valid?
    end

    it 'has a proper error message' do
      expect(subject.errors.messages[:check_vehicle_option]).to include('You must choose an answer')
    end
  end

  context 'when check_vehicle_option is invalid' do
    let(:check_vehicle_option) { 'invalid' }

    it { is_expected.not_to be_valid }

    before { subject.valid? }

    it 'has a proper error message' do
      expect(subject.errors.messages[:check_vehicle_option]).to include('You must choose an answer')
    end
  end
end
