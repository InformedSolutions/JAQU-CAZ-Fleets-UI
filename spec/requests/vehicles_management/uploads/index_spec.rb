# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::UploadsController - GET #index' do
  subject { get uploads_path }

  context 'correct permissions' do
    before { mock_fleet }

    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
