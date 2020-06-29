# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #index', type: :request do
  subject { get payments_path }

  context 'with empty fleet' do
    before do
      mock_fleet(create_empty_fleet)
      sign_in create_user
    end

    it 'redirects to #first_upload' do
      subject
      expect(response).to redirect_to first_upload_fleets_path
    end
  end

  context 'with vehicles in fleet' do
    before do
      mock_caz_list
      mock_fleet
      sign_in create_user
    end

    it 'renders payments page' do
      subject
      expect(response).to render_template('payments/index')
    end
  end
end
