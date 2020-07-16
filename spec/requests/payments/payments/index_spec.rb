# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
describe 'PaymentsController - #index' do
=======
describe 'PaymentsController - #index', type: :request do
>>>>>>> release-candidate/v1.2.0
  subject { get payments_path }

  before { sign_in create_user }

  context 'correct permissions' do
    context 'with empty fleet' do
      before do
        mock_fleet(create_empty_fleet)
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
      end

      it 'renders payments page' do
        subject
        expect(response).to render_template('payments/index')
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
