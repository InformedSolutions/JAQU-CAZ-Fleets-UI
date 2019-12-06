# frozen_string_literal: true

require 'rails_helper'

describe Sqs::VerificationEmail do
  let(:user) { create_user(user_id: user_id, account_id: account_id, email: email) }
  let(:user_id) { SecureRandom.uuid }
  let(:account_id) { SecureRandom.uuid }
  let(:email) { 'test@example.com' }
  let(:message_id) { SecureRandom.uuid }
  let(:host) { 'http://www.example.com' }

  describe '.call' do
    subject(:service) { described_class.call(user: user, host: host) }

    before do
      allow(AWS_SQS).to receive(:send_message).and_return(OpenStruct.new(message_id: message_id))
    end

    it 'returns message_id' do
      expect(service).to eq(message_id)
    end

    context 'when the call to SQS is unsuccessful' do
      before do
        allow(AWS_SQS).to receive(:send_message).and_raise(
          Aws::SQS::Errors::InvalidMessageContents.new('', '')
        )
      end

      it 'returns false' do
        expect(service).to be_falsey
      end
    end
  end

  describe 'private methods' do
    let(:service) { described_class.new(user: user, host: host) }

    describe '.token' do
      subject(:token) { service.send(:token) }

      it 'sets user_id' do
        expect(token[:user_id]).to eq(user_id)
      end

      it 'sets account_id' do
        expect(token[:account_id]).to eq(account_id)
      end

      it 'sets created_at in proper format' do
        freeze_time do
          expect(token[:created_at]).to eq(Time.current.iso8601)
        end
      end

      it 'adds salt' do
        expect(token[:salt]).not_to be_nil
      end
    end

    describe '.reference' do
      subject(:reference) { service.send(:reference) }

      it 'sets proper reference' do
        freeze_time do
          expect(reference).to eq("#{email}-#{Time.current.strftime('%H%M%S')}")
        end
      end
    end
  end
end
