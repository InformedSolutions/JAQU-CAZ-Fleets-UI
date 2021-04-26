# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsHistory::PaymentHistoryController - GET #payment_history_download', type: :request do
  subject { get payment_history_download_path }

  context 'when correct permissions' do
    before { sign_in user }

    let(:user) { view_payment_history_user }

    describe 'with `payment_history_file_url` in session' do
      before do
        add_to_session(payment_history_file_url: file_url)
        allow(PaymentHistory::ParseFileName).to receive(:call).and_return(file_name)
        subject
      end

      let(:file_url) { "https://example.com/bucket-name/#{file_name}" }
      let(:file_name) { 'Paymenthistory-25March2021-150501.csv' }

      it 'calls PaymentHistory::ParseFileName with proper params' do
        expect(PaymentHistory::ParseFileName).to have_received(:call).with(file_url: file_url)
      end

      it 'assigns :file_url variable' do
        expect(assigns(:file_url)).to eq(file_url)
      end

      it 'assigns :file_name variable' do
        expect(assigns(:file_name)).to eq(file_name)
      end

      it 'render the view' do
        expect(response).to render_template(:payment_history_download)
      end
    end

    describe 'without `payment_history_file_url` in session' do
      before { subject }

      it 'assigns :file_url variable' do
        expect(assigns(:file_url)).to be_nil
      end

      it 'assigns :file_name variable' do
        expect(assigns(:file_name)).to be_nil
      end

      it 'render the view' do
        expect(response).to render_template(:payment_history_download)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
