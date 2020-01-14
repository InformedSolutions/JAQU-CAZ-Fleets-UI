# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - #enter_details', type: :request do
  subject(:http_request) { get enter_details_vehicles_path }

  let(:no_vrn_path) { enter_details_vehicles_path }

  it_behaves_like 'a login required view'
end
