# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionMethodForm do
  subject(:form) { described_class.new(submission_method: submission_method) }

  let(:submission_method) { 'upload' }
  let(:error) { I18n.t('input_form.errors.missing', attribute: 'Submission method') }

  it { is_expected.to be_valid }

  describe '.manual?' do
    it { is_expected.not_to be_manual }
  end

  context 'when method is manual' do
    let(:submission_method) { 'manual' }

    it { is_expected.to be_valid }

    describe '.manual?' do
      it { is_expected.to be_manual }
    end
  end

  context 'when different method is submitted' do
    let(:submission_method) { 'test' }

    it { is_expected.not_to be_valid }

    it 'returns a proper error' do
      form.valid?
      expect(form.errors[:submission_method]).to eq([error])
    end
  end

  context 'when method is nil' do
    let(:submission_method) { nil }

    it { is_expected.not_to be_valid }

    it 'returns a proper error' do
      form.valid?
      expect(form.errors[:submission_method]).to eq([error])
    end
  end
end
