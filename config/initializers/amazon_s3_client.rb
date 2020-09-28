# frozen_string_literal: true

# Development environment config
access_key_id = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
assume_role_arn = ENV['AWS_ROLE_ARN']
assume_role_session_name = 'jaqu-lowerDeveloperRole-localdev'

# Production environment config
TASK_METADATA_ADDRESS = '169.254.170.2'

# Common environment config
region = ENV.fetch('AWS_REGION', 'eu-west-2')

credentials = if Rails.env.production?
                Aws::ECSCredentials.new({ ip_address: TASK_METADATA_ADDRESS })
              elsif Rails.env.test?
                Aws::Credentials.new(access_key_id, secret_access_key)
              else
                Aws::AssumeRoleCredentials.new(
                  client: Aws::STS::Client.new(
                    region: region,
                    access_key_id: access_key_id,
                    secret_access_key: secret_access_key
                  ),
                  role_arn: assume_role_arn,
                  role_session_name: assume_role_session_name
                )
              end

AMAZON_S3_CLIENT = Aws::S3::Resource.new(
  region: region,
  credentials: credentials
)
