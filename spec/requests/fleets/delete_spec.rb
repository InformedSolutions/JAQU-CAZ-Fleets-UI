# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #delete', type: :request do
  subject(:http_request) { get delete_fleets_path }
  let(:no_vrn_path) { fleets_path }

  it_behaves_like 'a vrn required view'
end
