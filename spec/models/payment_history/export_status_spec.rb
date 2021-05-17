# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::ExportStatus, type: :model do
  subject { described_class.new(account_id: account_id, job_id: job_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }
  let(:file_content_type) { 'text/csv' }
  let(:file_body) { 'body' }
  let(:s3_file) do
    instance_double('Aws::S3::Types::GetObjectOutput',
                    last_modified: Time.parse('2021-04-22T085031').utc,
                    content_type: file_content_type, body: file_body)
  end

  before do
    allow(AccountsApi::PaymentHistory).to receive(:payment_history_export_status)
      .and_return(read_response('payment_history/export_status.json'))
    allow(PaymentHistory::LoadFile).to receive(:call)
      .and_return(s3_file)
  end

  describe '.file_url' do
    it 'returns file url ' do
      expect(subject.file_url).to eq('https://example.com/payments.csv?X-Amz-Date=20210423T085031Z&X-Amz-Expires=3600')
    end
  end

  describe '.link_active?' do
    context 'when link is active' do
      let(:user) { create_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735') }

      before { travel_to Time.parse('2021-04-23T085031').utc }

      after { travel_to Time.parse('2021-04-23T085031').utc }

      it 'returns true' do
        expect(subject.link_active?).to eq(true)
      end
    end

    context 'when link is expired' do
      let(:user) { create_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735') }

      before { travel_to Time.parse('2021-07-24T085031').utc }

      after { travel_back }

      it 'returns false' do
        expect(subject.link_active?).to eq(false)
      end
    end
  end

  describe '.link_accessible_for?' do
    context 'when user is not a recipient' do
      let(:user) { create_user }

      it 'returns false' do
        expect(subject.link_accessible_for?(user)).to eq(false)
      end
    end

    context 'when user is a recipient' do
      let(:user) { create_user(user_id: '8734fdc7-2e37-4053-830a-033eae54f735') }

      it 'returns false' do
        expect(subject.link_accessible_for?(user)).to eq(true)
      end
    end
  end

  describe '.file_content_type' do
    before { travel_to Time.parse('2021-04-23T085031').utc }

    after { travel_back }

    it 'returns true' do
      expect(subject.file_content_type).to eq(file_content_type)
    end
  end

  describe '.file_body' do
    before { travel_to Time.parse('2021-04-23T085031').utc }

    after { travel_back }

    it 'returns true' do
      expect(subject.file_body).to eq(file_body)
    end
  end
end
