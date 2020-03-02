# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #matrix', type: :request do
  subject(:http_request) { get matrix_payments_path }

  let(:la_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' }
  let(:fleet) { create_chargeable_vehicles }

  before { sign_in create_user }

  context 'with la in the session' do
    before do
      mock_caz_list
      mock_fleet(fleet)
      add_to_session(new_payment: { la_id: la_id })
    end

    it 'is successful' do
      http_request
      expect(response).to have_http_status(:success)
    end

    it 'calls charges with right params' do
      expect(fleet).to receive(:charges).with(zone_id: la_id, direction: nil, vrn: nil)
      http_request
    end

    context 'with search data' do
      let(:search) { 'test' }

      before { add_to_session(payment_query: { search: search }) }

      it 'assigns search value' do
        http_request
        expect(assigns(:search)).to eq(search)
      end
    end

    context 'with vrn and direction data' do
      let(:direction) { 'next' }

      before { add_to_session(payment_query: { vrn: @vrn, direction: direction }) }

      it 'calls charges with right params' do
        expect(fleet).to receive(:charges).with(zone_id: la_id, direction: direction, vrn: @vrn)
        http_request
      end
    end
  end

  context 'without la in the session' do
    it 'redirects to index' do
      http_request
      expect(response).to redirect_to(payments_path)
    end
  end
end
