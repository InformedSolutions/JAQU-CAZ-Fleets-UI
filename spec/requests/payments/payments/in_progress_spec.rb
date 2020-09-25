# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #in_progress' do
  subject { get in_progress_payments_path }

  let(:caz_id) { @uuid }
  let(:user) { make_payments_user }

  context 'correct permissions' do
    let(:fleet) { create_chargeable_vehicles }

    before do
      add_caz_lock_to_redis(user)
      sign_in user
    end

    context 'with la in the session' do
      before do
        mock_clean_air_zones
        mock_fleet(fleet)
        add_to_session(new_payment: { caz_id: caz_id })
      end

      it 'returns a 200 OK status' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without la in the session' do
      it 'redirects to the index' do
        subject
        expect(response).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
