# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #add_vehicle', type: :request do
  subject(:http_request) { get add_vehicle_fleets_path }

  it_behaves_like 'a login required view'
end
