# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddQueryDetails do
  subject { described_class.call(params: params, session: session) }

  let(:id) { @uuid }
  let(:params) { { commit: commit, payment: { vrn_search: search } }.with_indifferent_access }
  let(:commit) { 'Search' }
  let(:search) { 'test' }
  let(:session) { {} }

  before { subject }

  it 'saves only the search value' do
    expect(session[:payment_query]).to eq({ search: search })
  end

  context 'when commit is Search' do
    let(:commit) { 'Search' }

    it 'saves the search value' do
      expect(session[:payment_query]).to eq(
        { search: search }
      )
    end
  end
end
