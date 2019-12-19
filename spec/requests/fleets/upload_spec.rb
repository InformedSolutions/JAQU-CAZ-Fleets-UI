# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #upload', type: :request do
  subject(:http_request) { get upload_fleets_path }

  it_behaves_like 'a login required view'
end
