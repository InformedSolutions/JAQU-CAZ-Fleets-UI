# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #clear_serach', type: :request do
  subject { get clear_search_payments_path }

  let(:la_id) { '5cd7441d-766f-48ff-b8ad-1809586fea37' }
  let(:fleet) { create_chargeable_vehicles }

  before { sign_in create_user }

  context 'with la in the session' do
    before do
      mock_caz_list
      mock_fleet(fleet)
      add_to_session(new_payment: { la_id: la_id })
      add_to_session(payment_query: { search: 'search' })
    end

    it 'clears search value' do
      subject
      expect(assigns(:search)).to be_nil
    end

    it 'redirects to matrix' do
      subject
      expect(response).to redirect_to(matrix_payments_path)
    end
  end
end
