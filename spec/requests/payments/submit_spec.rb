# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - #submit', type: :request do
  subject(:http_request) { post matrix_payments_path, params: params }

  let(:params) do
    {
      commit: commit,
      payment: {
        vehicles: { @vrn => dates },
        vrn_search: search,
        next_vrn: next_vrn,
        previous_vrn: prev_vrn,
        vrn_list: @vrn
      }
    }
  end

  let(:next_vrn) { 'CU1234' }
  let(:prev_vrn) { 'CAS123' }
  let(:commit) { 'Continue' }
  let(:dates) { ['2020-03-08'] }
  let(:search) { 'test' }

  before { sign_in create_user }

  it 'redirects to :index' do
    expect(http_request).to redirect_to(payments_path)
  end

  context 'with la_id and vehicle details in the session' do
    before do
      add_to_session(new_payment: {
                       la_id: SecureRandom.uuid,
                       details: { @vrn => { dates: [] } }
                     })
    end

    context 'when commit is continue' do
      it 'redirects to :review' do
        expect(http_request).to redirect_to(review_payments_path)
      end

      it 'saves new payment data' do
        http_request
        expect(session[:new_payment]['details'][@vrn][:dates]).to eq(dates)
      end
    end

    context 'when commit is search' do
      let(:commit) { 'Search' }

      it_behaves_like 'a non continue matrix commit'

      it 'saves only search' do
        http_request
        expect(session[:payment_query].keys).to contain_exactly(:search)
      end
    end

    context 'when commit is next' do
      let(:commit) { 'Next' }

      it_behaves_like 'a non continue matrix commit'

      it 'saves next vrn' do
        http_request
        expect(session[:payment_query][:vrn]).to eq(next_vrn)
      end

      it 'saves direction' do
        http_request
        expect(session[:payment_query][:direction]).to eq('next')
      end
    end

    context 'when commit is previous' do
      let(:commit) { 'Previous' }

      it_behaves_like 'a non continue matrix commit'

      it 'saves previous vrn' do
        http_request
        expect(session[:payment_query][:vrn]).to eq(prev_vrn)
      end

      it 'saves direction' do
        http_request
        expect(session[:payment_query][:direction]).to eq('previous')
      end
    end
  end
end
