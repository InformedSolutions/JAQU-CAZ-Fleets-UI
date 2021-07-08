# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::RemoveVehicles::UpdateVehiclesInSession do
  subject { described_class.call(params: params, session: session) }

  let(:params) { { 'remove_vehicles' => remove_vehicles, 'vrns_on_page' => vrns_on_page } }
  let(:remove_vehicles) { [vrn1] }
  let(:vrns_on_page) { 'ABC123 XYZ123' }
  let(:vrn1) { 'ABC123' }
  let(:vrn2) { 'XYZ123' }
  let(:vrn3) { 'CU57ABC' }
  let(:session) { { remove_vehicles_list: remove_vehicles_list } }
  let(:remove_vehicles_list) { [vrn3] }

  context 'when session is not empty' do
    context 'with vrn in session which is not present in `vrns_on_page` and not present in params' do
      before { subject }

      it 'updates session' do
        expect(session[:remove_vehicles_list]).to eq([vrn3, vrn1])
      end
    end

    context 'with vrn in session which is also present in `vrns_on_page` but not in params' do
      let(:remove_vehicles_list) { [vrn2, vrn3] }

      it 'updates session' do
        expect(session[:remove_vehicles_list]).to eq([vrn2, vrn3])
      end
    end
  end

  context 'when session in empty' do
    let(:session) { {} }

    before { subject }

    it 'updates session' do
      expect(session[:remove_vehicles_list]).to eq([vrn1])
    end
  end
end
