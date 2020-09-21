# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #matrix' do
  subject { get matrix_payments_path }

  context 'correct permissions' do
    let(:fleet) { create_chargeable_vehicles }

    before { sign_in create_user }

    context 'with la in the session' do
      before do
        mock_clean_air_zones
        mock_fleet(fleet)
        add_to_session(new_payment: { caz_id: @uuid })
      end

      it 'is successful' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'calls charges with right params' do
        expect(fleet).to receive(:charges).with(zone_id: @uuid, direction: nil, vrn: nil)
        subject
      end

      it 'assigns the @d_day_notice' do
        subject
        expect(assigns(:d_day_notice)).to eq(false)
      end

      context 'with search data' do
        let(:search) { 'test' }

        before { add_to_session(payment_query: { search: search }) }

        it 'assigns search value' do
          subject
          expect(assigns(:search)).to eq(search)
        end
      end

      context 'with vrn and direction data' do
        let(:direction) { 'next' }

        before { add_to_session(payment_query: { vrn: @vrn, direction: direction }) }

        it 'calls charges with right params' do
          expect(fleet).to receive(:charges).with(zone_id: @uuid, direction: direction, vrn: @vrn)
          subject
        end
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
