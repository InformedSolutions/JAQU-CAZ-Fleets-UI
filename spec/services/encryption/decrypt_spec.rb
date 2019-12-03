# frozen_string_literal: true

require 'rails_helper'

describe Encryption::Decrypt do
  subject(:service) { described_class.call(value: token) }

  let(:value) { { test: 'test' } }
  let(:token) { Encryption::Encrypt.call(value: value) }

  it 'decrypts message' do
    expect(service).to eq(value)
  end
end
