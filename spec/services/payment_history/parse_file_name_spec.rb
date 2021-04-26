# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentHistory::ParseFileName do
  subject { described_class.call(file_url: file_url) }

  let(:file_url) { "https://example.com/bucket-name/#{file_name}?X-Amz-Security-Token=IQo" }
  let(:file_name) { 'Paymenthistory-25March2021-150501.csv' }

  describe '#call'  do
    describe 'when `file_url` is valid url' do
      it 'returns a proper value' do
        expect(subject).to eq(file_name)
      end
    end

    describe 'when `file_url` is invalid url' do
      let(:file_url) { 'https://invalid##host.com' }

      it 'returns a nil' do
        expect(subject).to be_nil
      end
    end
  end
end
