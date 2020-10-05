# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - GET #export' do
  subject { get export_fleets_path }

  let(:file_url) { 'https://example.com/bucket-name/file.csv' }

  context 'correct permissions' do
    before do
      allow(AccountsApi).to receive(:csv_exports).and_return(file_url)
      sign_in manage_vehicles_user
      subject
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to file url' do
      expect(response).to redirect_to(file_url)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
