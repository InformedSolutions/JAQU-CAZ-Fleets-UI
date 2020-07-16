# frozen_string_literal: true

require 'rails_helper'

<<<<<<< HEAD
describe 'DirectDebits::DebitsController - GET #confirm' do
=======
describe 'DebitsController - GET #confirm' do
>>>>>>> release-candidate/v1.2.0
  subject { get confirm_debits_path }

  context 'correct permissions' do
    before do
      add_to_session(new_payment: { la_id: @uuid, details: {} })
      mock_clean_air_zones
      sign_in(make_payments_user)
    end

    context 'when zone have some active mandates' do
      before { mock_caz_mandates('caz_mandates') }

      it 'returns 200' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'when zone does not have any active mandates' do
      before { allow(DebitsApi).to receive(:caz_mandates).and_return([]) }

      it 'redirects to the create a first mandate page' do
        subject
        expect(response).to redirect_to(first_mandate_debits_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
