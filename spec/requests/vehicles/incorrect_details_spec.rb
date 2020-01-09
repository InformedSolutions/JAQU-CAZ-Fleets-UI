# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - #incorrect_details', type: :request do
  subject(:http_request) { get incorrect_details_vehicles_path }

  let(:no_vrn_path) { enter_details_vehicles_path }

  it_behaves_like 'a vrn required view'
end
