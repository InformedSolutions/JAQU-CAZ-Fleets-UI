# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #index' do
  subject { get payments_path }

  before { sign_in create_user }

  context 'correct permissions' do
    context 'with empty fleet' do
      before do
        mock_fleet(create_empty_fleet)
      end

      it 'redirects to first upload page' do
        subject
        expect(response).to redirect_to first_upload_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before do
        mock_clean_air_zones
        mock_fleet
      end

      it 'renders payments page' do
        subject
        expect(response).to render_template(:index)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
