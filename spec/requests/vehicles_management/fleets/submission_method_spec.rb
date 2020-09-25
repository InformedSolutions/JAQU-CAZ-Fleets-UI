# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #submission_method' do
  subject { get submission_method_fleets_path }

  context 'correct permissions' do
    before do
      sign_in manage_vehicles_user
      mock_users
    end

    it 'renders the view' do
      expect(subject).to render_template(:submission_method)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
