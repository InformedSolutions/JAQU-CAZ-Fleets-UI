# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddPaymentDetails do
  subject(:service) do
    described_class.call(params: params, session: session)
  end

  let(:id) { SecureRandom.uuid }
  let(:params) { { payment: { vehicles: vehicles_data } } }
  let(:vehicles_data) { { @vrn => dates } }
  let(:session) { { new_payment: { la_id: id } } }
  let(:dates) { %w[2019-11-04 2019-11-05] }

  before { service }

  it 'adds details for @vrn' do
    expect(session[:new_payment][:details]).to eq(vehicles_data)
  end

  it 'keeps LA ID' do
    expect(session[:new_payment][:la_id]).to eq(id)
  end

  context 'with empty session' do
    let(:session) { {} }

    it 'adds details for @vrn' do
      expect(session[:new_payment][:details]).to eq(vehicles_data)
    end
  end

  context 'with other dates for @vrn' do
    let(:session) { { new_payment: { la_id: id, details: { @vrn => ['2019-11-06'] } } } }

    it 'overrides details for @vrn' do
      expect(session[:new_payment][:details]).to eq(vehicles_data)
    end
  end

  context 'with details for another vehicle' do
    let(:other_details) { { 'CU12345' => ['2019-11-06'] } }
    let(:session) { { new_payment: { la_id: id, details: other_details } } }

    it 'keeps details for both' do
      expect(session[:new_payment][:details]).to eq(vehicles_data.merge(other_details))
    end
  end

  context 'with empty params' do
    let(:params) { {} }

    it 'creates empty hash in the session' do
      expect(session[:new_payment][:details]).to eq({})
    end
  end
end
