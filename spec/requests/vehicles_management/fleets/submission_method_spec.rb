# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #submission_method' do
  subject { get submission_method_fleets_path }

  context 'correct permissions' do
    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
