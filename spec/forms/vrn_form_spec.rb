# frozen_string_literal: true

require 'rails_helper'

describe VrnForm, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'ABC123' }

  it { is_expected.to be_valid }
  it { expect(subject.vrn).to eq(vrn) }

  context 'when vrn includes spaces and small letters and leading zeros' do
    let(:vrn) { '00AbC 12 3' }

    it 'removes spaces and leading zeros and upcases the vrn' do
      expect(subject.vrn).to eq('ABC123')
    end
  end

  context 'when vrn is nil' do
    let(:vrn) { nil }

    it_behaves_like 'an invalid VrnForm', I18n.t('vrn_form.errors.vrn_missing')
  end

  context 'when vrn is too short' do
    let(:vrn) { 'A' }

    it_behaves_like 'an invalid VrnForm', I18n.t('vrn_form.errors.vrn_too_short')
  end

  context 'when vrn is too long' do
    let(:vrn) { 'AAAAAAAA' }

    it_behaves_like 'an invalid VrnForm', I18n.t('vrn_form.errors.vrn_too_long')
  end

  context 'when vrn is in invalid format' do
    let(:vrn) { 'AAAAA' }

    it_behaves_like 'an invalid VrnForm', I18n.t('vrn_form.errors.vrn_invalid')
  end

  context 'when VRN starts with 0 and is with 0 stripped' do
    let(:vrn) { '009999A' }

    it { is_expected.to be_valid }

    it 'removes leading zeros and upcases the vrn' do
      expect(subject.vrn).to eq('9999A')
    end
  end
end
