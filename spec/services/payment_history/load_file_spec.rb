# frozen_string_literal: true

require 'rails_helper'

describe PaymentHistory::LoadFile, type: :model do
  subject { described_class.new(file_url: file_url) }

  let(:file_url) { 'test_file.csv' }
  let(:file) { 'file' }

  context 'when file found in s3' do
    before do
      mock = instance_double(Aws::S3::Object, get: file)
      allow(Aws::S3::Object).to receive(:new).and_return(mock)
    end

    describe '.call' do
      it 'returns file object from aws s3' do
        expect(subject.call).to eq(file)
      end
    end
  end

  context 'when file not found in s3' do
    before do
      allow(Aws::S3::Object).to(
        receive(:new).and_raise(Aws::S3::Errors::NoSuchKey.new(400, '', {}))
      )
    end

    describe '.call' do
      it 'returns file object from aws s3' do
        expect(subject.call).to eq(nil)
      end
    end
  end
end
