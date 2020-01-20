# frozen_string_literal: true

AMAZON_S3_CLIENT = Aws::S3::Resource.new(
  region: ENV.fetch('S3_AWS_REGION', 'eu-west-2'),
  access_key_id: ENV.fetch('S3_AWS_ACCESS_KEY_ID', 'AAAAAAAAAAAAAAA'),
  secret_access_key: ENV.fetch('S3_AWS_SECRET_ACCESS_KEY', 'aaaaaaaaaaaaaaaaaaaaaaaaa')
)
