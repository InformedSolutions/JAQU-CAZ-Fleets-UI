# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::ExportStatus, type: :model do
  subject { described_class.new(account_id: account_id, job_id: job_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }

  before do
    allow(AccountsApi::PaymentHistory).to receive(:payment_history_export_status)
      .and_return(read_response('payment_history/export_status.json'))
  end

  describe '.recipient_account_user_id' do
    it 'returns user id' do
      expect(subject.recipient_account_user_id).to eq('8734fdc7-2e37-4053-830a-033eae54f735')
    end
  end

  describe '.file_url' do
    it 'returns file url ' do
      expect(subject.file_url).to eq('https://example.com/payments.csv?X-Amz-Date=20210423T085031Z&X-Amz-Expires=3600')
    end
  end

  describe '.link_active_for?' do
    context 'when link is active and user is recipient' do
      let(:user) { create_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735') }

      before do
        travel_to Time.parse('2021-04-23T085031').utc
      end

      after do
        travel_back
      end

      it 'returns true' do
        expect(subject.link_active_for?(user)).to eq(true)
      end
    end

    context 'when link is active and user is not a recipient' do
      let(:user) { create_user }

      before do
        travel_to Time.parse('2021-04-23T085031').utc
      end

      after do
        travel_back
      end

      it 'returns false' do
        expect(subject.link_active_for?(user)).to eq(false)
      end
    end

    context 'when link is expired and user is a recipient' do
      let(:user) { create_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735') }

      before do
        travel_to Time.parse('2021-04-24T085031').utc
      end

      after do
        travel_back
      end

      it 'returns false' do
        expect(subject.link_active_for?(user)).to eq(false)
      end
    end
  end
end
