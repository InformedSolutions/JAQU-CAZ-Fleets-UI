# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - #local_exemptions', type: :request do
  subject(:http_request) { get local_exemptions_vehicles_path }

  it_behaves_like 'a login required view'
end
