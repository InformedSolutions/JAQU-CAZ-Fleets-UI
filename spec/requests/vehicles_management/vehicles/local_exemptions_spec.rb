# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #local_exemptions' do
  subject { get local_exemptions_vehicles_path }

  context 'correct permissions' do
    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
