# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::UploadFile do
  subject { described_class.call(file: file, user: create_user(user_id: id)) }

  let(:file) { fixture_file_upload(file_path) }
  let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.csv') }
  let(:id) { @uuid }

  describe '#call' do
    context 'with valid params' do
      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(true)
      end

      it 'returns the proper file name' do
        freeze_time do
          expect(subject).to eq("fleet_#{id}_#{Time.current.to_i}")
        end
      end
    end

    context 'with invalid extension' do
      let(:file_path) { File.join('spec', 'fixtures', 'uploads', 'fleet.txt') }

      it 'raises a proper exception' do
        expect { subject }.to raise_exception(
          CsvUploadException, I18n.t('csv.errors.invalid_ext')
        )
      end
    end

    context 'with invalid params' do
      context 'when `ValidateCsvService` returns error' do
        let(:file) { nil }

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(
            CsvUploadException, I18n.t('csv.errors.no_file')
          )
        end
      end

      context 'when file size is too big' do
        before { allow(file).to receive(:size).and_return(52_428_801) }

        it 'raises exception' do
          expect { subject }.to raise_exception(CsvUploadException)
        end
      end

      context 'when `S3UploadService` returns error' do
        before do
          allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).and_return(false)
        end

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, I18n.t('csv.errors.base'))
        end
      end

      context 'when S3 raises an exception' do
        before do
          allow_any_instance_of(Aws::S3::Object)
            .to receive(:upload_file)
            .and_raise(Aws::S3::Errors::MultipartUploadError.new('', ''))
        end

        it 'raises a proper exception' do
          expect { subject }.to raise_exception(CsvUploadException, I18n.t('csv.errors.base'))
        end
      end
    end
  end
end
