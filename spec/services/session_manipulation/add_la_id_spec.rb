# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddLaId do
  subject { described_class.call(params: params, session: session) }

  let(:id) { SecureRandom.uuid }
  let(:params) { { 'local-authority' => id } }
  let(:session) { {} }

  before { subject }

  it 'sets la_id' do
    expect(session[:new_payment]).to eq({ la_id: id })
  end

  context 'when there is other data in the session' do
    let(:session) do
      { new_payment: { la_id: SecureRandom.uuid, details: { @vrn => [] } } }
    end

    it 'it clears other data than la_id' do
      expect(session[:new_payment]).to eq({ la_id: id })
    end
  end

  context 'when there is data for the same LA' do
    let(:payment_data) { { la_id: id, details: { @vrn => [] } } }
    let(:session) do
      { new_payment: payment_data }
    end

    it 'keeps the data' do
      expect(session[:new_payment]).to eq(payment_data)
    end
  end

  context 'when query params are present' do
    let(:session) do
      { payment_query: { search: @vrn } }
    end

    it 'removes payment query' do
      expect(session.keys).not_to include(:payment_query)
    end
  end
end
