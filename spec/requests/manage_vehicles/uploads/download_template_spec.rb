# frozen_string_literal: true

require 'rails_helper'

describe 'UploadsController - #download template' do
  subject { get download_template_uploads_path }

  before do
    sign_in create_user
    subject
  end

  it 'returns a proper file' do
    expect(response.body).to eq(File.read(Rails.root.join('public/template.csv')))
  end

  it 'has text/csv content type header' do
    expect(response.headers['Content-Type']).to eq('text/csv')
  end

  it 'names the file properly' do
    expect(response.headers['Content-Disposition']).to include('VehicleUploadTemplate.csv')
  end
end
