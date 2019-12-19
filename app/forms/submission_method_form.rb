# frozen_string_literal: true

##
# Form used by FleetsController.submit_method to validate submitted method
#
class SubmissionMethodForm < BaseForm
  attr_accessor :submission_method

  # Validates if the method is either +upload+ or +manual+
  validates :submission_method, inclusion: {
    message: I18n.t('input_form.errors.missing'),
    allow_blank: false,
    in: %w[upload manual]
  }

  # Return true if submitted method is +manual+
  def manual?
    submission_method == 'manual'
  end
end
