# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #enter_details' do
  subject { get enter_details_vehicles_path }

  context 'correct permissions' do
    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
