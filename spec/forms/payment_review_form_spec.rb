# frozen_string_literal: true

require 'rails_helper'

describe PaymentReviewForm, type: :model do
  subject(:form) { described_class.new(confirmation) }

  let(:confirmation) { 'yes' }

  it { is_expected.to be_valid }

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(form.confirmed?).to eq(true)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }
    let(:error_message) { I18n.t('payment_review.errors.confirmation_alert') }

    it { is_expected.not_to be_valid }

    before do
      form.valid?
    end

    it 'has a proper error message' do
      expect(form.errors.messages[:confirmation]).to include(error_message)
    end
  end
end
