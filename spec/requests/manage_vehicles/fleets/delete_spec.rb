# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #delete', type: :request do
  subject { get delete_fleets_path }
  let(:no_vrn_path) { fleets_path }

  it_behaves_like 'a vrn required view'
end
