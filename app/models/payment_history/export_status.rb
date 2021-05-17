# frozen_string_literal: true

##
# Module used for payment history flow
module PaymentHistory
  ##
  # Wraps information about export status returned by the API call.
  #
  class ExportStatus
    ##
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - UUID, id of the account
    # * +job_id+ - Integer, id of the job responsible for payment history CSV processing
    #
    def initialize(account_id:, job_id:)
      @account_id = account_id
      @job_id = job_id
    end

    # Returns a string with AWS signed URL
    def file_url
      api_data['fileUrl']
    end

    # Calculates if an URL is still active and returns a boolean
    def link_active?
      file.present? && file.last_modified + file_expiration_days >= Time.current.utc
    end

    # Calculates if an URL is accessible for provided user
    def link_accessible_for?(user)
      recipient_account_user_id == user.user_id
    end

    delegate :body, :content_type, to: :file, prefix: true

    private

    attr_reader :account_id, :job_id

    # Returns a string with UUID
    def recipient_account_user_id
      api_data['recipientAccountUserId']
    end

    # Performs an API call to receive payment history export status data.
    def api_data
      @api_data ||= AccountsApi::PaymentHistory.payment_history_export_status(
        account_id: account_id, job_id: job_id
      )
    end

    # Performs an API call to receive payment history export status data.
    def file
      @file ||= PaymentHistory::LoadFile.call(file_url: file_url)
    end

    # Returns number of expiration days for file
    def file_expiration_days
      Rails.configuration.x.csv_file_size_limit.days
    end
  end
end
