# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #submit_method', type: :request do
  subject { post submission_method_fleets_path, params: params }

  let(:params) { { 'submission-method': submission_method } }

  before { sign_in create_user }

  context 'without submission method' do
    let(:submission_method) { nil }

    it 'renders #submission_method' do
      expect(subject).to render_template('fleets/submission_method')
    end
  end

  context 'with upload as method' do
    let(:submission_method) { 'upload' }

    it 'redirects to uploads#index' do
      subject
      expect(response).to redirect_to(uploads_path)
    end
  end

  context 'with manual as method' do
    let(:submission_method) { 'manual' }

    it 'redirects to vehicles#enter_details' do
      subject
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end
end
