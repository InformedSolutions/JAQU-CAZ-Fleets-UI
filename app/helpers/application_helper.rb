# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation
#
module ApplicationHelper
  # Returns name of service, eg. 'FleetsUI'.
  def service_name
    Rails.configuration.x.service_name
  end

  # Remove duplicated error messages, e.g. `Password and password confirmation must be the same`
  def remove_duplicated_messages(errors)
    transformed_errors(errors).uniq(&:first)
  end

  # Transform hash of errors:
  # {
  #   :email=>["Email is in an invalid format"],
  #   :password_confirmation=>["Password and password confirmation must be the same"]
  # }
  # to array:
  # [
  #   ["Email is in an invalid format", :email],
  #   ["Password and password confirmation must be the same",:password_confirmation]
  # ]
  #
  def transformed_errors(errors)
    errors.map { |error| error.second.map { |msg| [msg, error.first] } }.flatten(1)
  end

  # Determinate input field class.
  # If error is present add `govuk-input--error` error class to field class.
  def determinate_input_class(field_error)
    "govuk-input govuk-!-width-two-thirds #{'govuk-input--error' if field_error.present?}"
  end

  # Returns a 'govuk-header__navigation-item--active' if current path equals a new path.
  def current_path?(path)
    'govuk-header__navigation-item--active' if request.path_info == path
  end
end
