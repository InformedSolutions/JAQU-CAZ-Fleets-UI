# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - #exempt', type: :request do
  subject { get exempt_vehicles_path }

  let(:no_vrn_path) { enter_details_vehicles_path }

  it_behaves_like 'a vrn required view'
end
