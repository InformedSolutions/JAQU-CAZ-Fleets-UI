# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - POST #submit_edit', type: :request do
  subject { post submit_edit_fleets_path, params: params }

  let(:params) { { edit_option: edit_option } }
  let(:edit_option) { 'add_single' }

  context 'when correct permissions' do
    before do
      mock_actual_account_name
      sign_in manage_vehicles_user
      subject
    end

    context 'with add_single as edit_option' do
      it 'redirects to the add single vehicle method' do
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end

    context 'with add_multiple as edit_option' do
      let(:edit_option) { 'add_multiple' }

      it 'redirects to the add multiple vehicle method' do
        expect(response).to redirect_to(uploads_path)
      end
    end

    context 'with remove as edit_option' do
      let(:edit_option) { 'remove' }

      it 'redirects to the remove vehicles page' do
        expect(response).to redirect_to(remove_vehicles_fleets_path)
      end
    end

    context 'without edit_option' do
      let(:edit_option) { nil }

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end
    end

    context 'with invalid edit_option' do
      let(:edit_option) { 'invalid' }

      it 'renders the view' do
        expect(response).to render_template(:edit)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
