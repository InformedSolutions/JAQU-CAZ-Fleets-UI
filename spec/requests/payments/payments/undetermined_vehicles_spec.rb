# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #undetermined_vehicles', type: :request do
  subject { get undetermined_vehicles_payments_path }

  context 'when correct permissions' do
    before do
      mock_clean_air_zones
      mock_chargeable_vehicles
      sign_in create_user
      add_to_session(new_payment: { caz_id: mocked_uuid })
      subject
    end

    it 'calls CleanAirZone.all to find CAZ' do
      expect(CleanAirZone).to have_received(:all)
    end

    it 'assigns :clean_air_zone_name variable' do
      expect(assigns(:clean_air_zone_name)).to eq('Birmingham')
    end
  end

  it_behaves_like 'incorrect permissions'
end
