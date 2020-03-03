# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddQueryDetails do
  subject(:service) do
    described_class.call(params: params, session: session)
  end

  let(:id) { SecureRandom.uuid }
  let(:params) do
    {
      commit: commit,
      payment: { vrn_search: search, next_vrn: vrn1, previous_vrn: vrn2 }
    }.with_indifferent_access
  end
  let(:commit) { 'Search' }
  let(:search) { 'test' }
  let(:vrn1) { 'CAZ300' }
  let(:vrn2) { 'CAZ400' }
  let(:session) { {} }

  before { service }

  it 'saves only the search value' do
    expect(session[:payment_query]).to eq({ search: search })
  end

  context 'with empty search value' do
    let(:search) { nil }

    it 'creates an empty hash' do
      expect(session[:payment_query]).to eq({})
    end
  end

  context 'when commit is Next' do
    let(:commit) { 'Next' }

    it 'saves the search, next VRN and direction value' do
      expect(session[:payment_query]).to eq(
        { search: search, vrn: vrn1, direction: 'next' }
      )
    end
  end

  context 'when commit is Previous' do
    let(:commit) { 'Previous' }

    it 'saves the search, next VRN and direction value' do
      expect(session[:payment_query]).to eq(
        { search: search, vrn: vrn2, direction: 'previous' }
      )
    end
  end
end
