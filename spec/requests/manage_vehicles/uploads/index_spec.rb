# frozen_string_literal: true

require 'rails_helper'

describe 'UploadsController - #index' do
  subject { get uploads_path }

  before { mock_fleet }
  it_behaves_like 'a login required'
end
