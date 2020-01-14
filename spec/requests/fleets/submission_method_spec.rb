# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #submission_method', type: :request do
  subject(:http_request) { get submission_method_fleets_path }

  it_behaves_like 'a login required view'
end
