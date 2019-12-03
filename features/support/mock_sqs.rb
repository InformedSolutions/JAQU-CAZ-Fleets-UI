# frozen_string_literal: true

module MockSqs
  def mock_verification_email
    allow(Sqs::VerificationEmail).to receive(:call).and_return(SecureRandom.uuid)
  end
end

World(MockSqs)
