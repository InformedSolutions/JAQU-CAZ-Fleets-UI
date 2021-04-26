# frozen_string_literal: true

require 'rails_helper'

describe AwsSignedUrl, type: :model do
  subject { described_class.new(url) }

  let(:url) { 'https://example.com/payments.csv?X-Amz-Date=20210423T085031Z&X-Amz-Expires=3600' }

  describe '.expires_at' do
    it 'returns Time object' do
      expect(subject.expires_at).to be_a(Time)
    end

    it 'returns calculated time' do
      expect(subject.expires_at.to_s).to eq('2021-04-23 09:50:31 UTC')
    end
  end
end
