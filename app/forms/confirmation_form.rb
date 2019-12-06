# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/users/manage.html.haml+.
class ConfirmationForm
  include ActiveModel::Validations

  validates :confirmation, inclusion: {
    in: %w[yes no], message: I18n.t('confirmation_form.answer_missing')
  }

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +confirmation+ - string, eg. 'yes'
  #
  def initialize(confirmation)
    @confirmation = confirmation
  end

  # Checks if +confirmation+ equality to 'yes'.
  #
  # Returns a boolean.
  def confirmed?
    confirmation == 'yes'
  end

  private

  # form confirmation from the query params, values: 'yes', 'no', nil
  attr_reader :confirmation
end
