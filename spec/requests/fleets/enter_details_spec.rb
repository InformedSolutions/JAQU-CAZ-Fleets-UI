# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #enter_details', type: :request do
  subject(:http_request) { get enter_details_fleets_path }

  it_behaves_like 'a login required view'
end
