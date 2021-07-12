# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::EditFleetForm, type: :model do
  subject { described_class.new(edit_option) }

  let(:edit_option) { 'add_single' }

  it { is_expected.to be_valid }

  context 'when edit_option is empty' do
    let(:edit_option) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(subject.errors.messages[:edit_option]).to include('You must choose an option')
    end
  end

  context 'when edit_option is invalid' do
    let(:edit_option) { 'invalid' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(subject.errors.messages[:edit_option]).to include('You must choose an option')
    end
  end
end
