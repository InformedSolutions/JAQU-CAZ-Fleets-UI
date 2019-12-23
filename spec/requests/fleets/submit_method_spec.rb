# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - #submit_method', type: :request do
  subject(:http_request) { post submission_method_fleets_path, params: params }

  let(:params) { { 'submission-method': submission_method } }

  before { sign_in create_user }

  context 'without submission method' do
    let(:submission_method) { nil }

    it 'renders #submission_method' do
      expect(http_request).to render_template('fleets/submission_method')
    end
  end

  context 'with upload as method' do
    let(:submission_method) { 'upload' }

    it 'redirects to #upload' do
      http_request
      expect(response).to redirect_to(upload_fleets_path)
    end
  end

  context 'with manual as method' do
    let(:submission_method) { 'manual' }

    it 'redirects to #add_vehicle' do
      http_request
      expect(response).to redirect_to(add_vehicle_fleets_path)
    end
  end
end
