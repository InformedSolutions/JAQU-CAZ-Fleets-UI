# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #index', type: :request do
  subject(:http_request) { get fleets_path }

  context 'with empty fleet' do
    before do
      allow(Fleet).to receive(:new).and_return(create_empty_fleet)
      sign_in create_user
    end

    it 'redirects to  #submission_method' do
      http_request
      expect(response).to redirect_to submission_method_fleets_path
    end
  end

  context 'with vehicles in fleet' do
    before { allow(Fleet).to receive(:new).and_return(create_fleet) }

    it_behaves_like 'a login required view'
  end
end
