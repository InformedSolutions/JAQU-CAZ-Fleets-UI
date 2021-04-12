# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::UploadFile do
  subject { described_class.call(file: file, user: create_user(user_id: id)) }

  let(:file) { Rack::Test::UploadedFile.new(file_path) }
  let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.csv') }
  let(:id) { SecureRandom.uuid }
  let(:upload_file) { true }

  before do
    mock = instance_double(Aws::S3::Object, upload_file: upload_file)
    allow(Aws::S3::Object).to receive(:new).and_return(mock)
  end

  describe '#call' do
    context 'with valid params' do
      it 'returns the proper file name' do
        freeze_time { expect(subject.filename).to eq("fleet_#{id}_#{Time.current.to_i}") }
      end

      it 'returns a proper value' do
        expect(subject).not_to be_large_fleet
      end
    end

    context 'with invalid extension' do
      let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.txt') }

      it 'raises a proper exception' do
        expect { subject }.to raise_exception(CsvUploadException, I18n.t('csv.errors.invalid_ext'))
      end
    end

    context 'with invalid params' do
      context 'when no file chosen' do
        let(:file) { nil }

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, 'Select a CSV file to upload')
        end
      end

      context 'when file size is too big' do
        before { allow(file).to receive(:size).and_return(52_428_801) }

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, 'The CSV must be smaller than 50MB')
        end
      end

      context 'when fleet size is too big' do
        before { allow(VehiclesManagement::CountVehicles).to receive(:call).and_return(2_000_001) }

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(
            CsvUploadException,
            'The file you are uploading contains more than 200k vehicles, the maximum number allowed'
          )
        end
      end

      context 'when `S3UploadService` returns error' do
        let(:upload_file) { false }

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, I18n.t('csv.errors.base'))
        end
      end

      context 'when S3 raises an exception' do
        before do
          allow(Aws::S3::Object).to receive(:new).and_raise(Aws::S3::Errors::MultipartUploadError.new('', ''))
        end

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, I18n.t('csv.errors.base'))
        end
      end
    end
  end

  describe '#large_fleet?' do
    before { allow(VehiclesManagement::CountVehicles).to receive(:call).and_return(5) }

    context 'when uploaded file is less than threshold' do
      it { expect(subject).not_to be_large_fleet }
    end

    context 'when uploaded file is not less than threshold' do
      before { Rails.configuration.x.large_fleet_threshold = 5 }

      it { expect(subject).to be_large_fleet }
    end
  end
end
