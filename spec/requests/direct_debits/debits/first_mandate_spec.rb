# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
describe 'DirectDebits::DebitsController - GET #first_mandate' do
=======
describe 'DebitsController - GET #first_mandate' do
>>>>>>> release-candidate/v1.2.0
  subject { get first_mandate_debits_path }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { la_id: @uuid, details: {} })
      sign_in(make_payments_user)
    end

    context 'with inactive mandates' do
      before do
        mock_caz_mandates('inactive_caz_mandates')
        subject
      end

      it 'returns 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with active mandates' do
      before do
        mock_caz_mandates
        subject
      end

      it 'redirects to the debits page' do
        expect(response).to redirect_to(debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
