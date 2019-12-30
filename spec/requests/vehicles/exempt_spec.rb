# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - #exempt', type: :request do
  subject(:http_request) { get exempt_vehicles_path }

  it_behaves_like 'a vrn required view'
end
