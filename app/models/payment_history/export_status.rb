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

    # Returns a string with UUID
    def recipient_account_user_id
      api_data['recipientAccountUserId']
    end

    # Returns a string with AWS signed URL
    def file_url
      api_data['fileUrl']
    end

    # Calculates if an URL is still active and returns a boolean
    def link_active_for?(user)
      Time.current.utc < signed_url_data.expires_at && recipient?(user)
    end

    # Checks if the provided {User}[rdoc-ref:User] object is the recipient of the email
    def recipient?(user)
      recipient_account_user_id == user.user_id
    end

    private

    attr_reader :account_id, :job_id

    # Performs an API call to receive payment history export status data.
    def api_data
      @api_data ||= AccountsApi::PaymentHistory.payment_history_export_status(account_id: account_id,
                                                                              job_id: job_id)
    end

    # Wraps the received URL into AwsSignedUrl class
    def signed_url_data
      AwsSignedUrl.new(file_url)
    end
  end
end
