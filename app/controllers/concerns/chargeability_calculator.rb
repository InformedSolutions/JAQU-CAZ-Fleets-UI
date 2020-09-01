# frozen_string_literal: true

# Module used to check upload job status
module ChargeabilityCalculator
  extend ActiveSupport::Concern

  private

  # Checks job status and depends on it adding a flash message and redirects to proper page
  def check_job_status
    return unless job_id && job_correlation_id

    status = FleetsApi.job_status(job_id: job_id, correlation_id: job_correlation_id)[:status].upcase
    handle_job_status(status)
  end

  # Adding hash to redis
  def add_data_to_redis(correlation_id, job_id)
    REDIS.hmset(account_id_redis_key, 'job_id', job_id, 'correlation_id', correlation_id)
  end

  # Handles controller reaction based on the given job status
  def handle_job_status(status)
    case status
    when 'SUCCESS'
      flash.now[:success] = I18n.t('vrn_form.messages.multiple_vrns_added', vrns_count: vehicles_count)
    when 'CHARGEABILITY_CALCULATION_IN_PROGRESS'
      redirect_to calculating_chargeability_uploads_path
    when 'RUNNING'
      redirect_to processing_uploads_path
    end
  end

  # Returns job_id for pending job
  def job_id
    REDIS.hget(account_id_redis_key, 'job_id')
  end

  # Returns correlation_id for pending job
  def job_correlation_id
    REDIS.hget(account_id_redis_key, 'correlation_id')
  end

  # Clears pending job data for current user
  def clear_job_data
    REDIS.del(account_id_redis_key)
  end

  # Returns string, e.g. 'account_id_214e8858-5f61-44be-b17d-571a94bee1b0'
  def account_id_redis_key
    "account_id_#{current_user.account_id}"
  end

  # Current user vehicles count
  def vehicles_count
    @fleet.total_vehicles_count
  end
end
