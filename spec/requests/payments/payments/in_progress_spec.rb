# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #in_progress' do
  subject { get in_progress_payments_path }

  let(:caz_id) { @uuid }
  let(:user) { make_payments_user }
  let(:caz_lock_key) { "caz_lock_#{user.account_id}_#{caz_id}" }

  context 'correct permissions' do
    let(:fleet) { create_chargeable_vehicles }

    before do
      add_caz_lock_to_redis(SecureRandom.uuid)
      sign_in user
    end

    context 'with la in the session' do
      before do
        mock_caz_list
        mock_fleet(fleet)
        add_to_session(new_payment: { caz_id: caz_id })
      end

      it 'is successful' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'without la in the session' do
      it 'redirects to index' do
        subject
        expect(response).to redirect_to(payments_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end