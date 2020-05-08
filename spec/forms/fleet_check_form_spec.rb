# frozen_string_literal: true

require 'rails_helper'

describe FleetCheckForm, type: :model do
  subject(:form) { described_class.new(confirm_fleet_check: confirm_fleet_check) }

  let(:confirm_fleet_check) { 'less_than_two' }

  it { is_expected.to be_valid }

  context 'when confirm_fleet_check is empty' do
    let(:confirm_fleet_check) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:confirm_fleet_check]).to include(I18n.t('form.errors.missing'))
    end
  end
end
