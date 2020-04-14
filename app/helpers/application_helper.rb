# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation
#
module ApplicationHelper
  # Returns name of service, eg. 'Fleets UI'.
  def service_name
    Rails.configuration.x.service_name
  end

  # Remove duplicated error messages, e.g. `Password and password confirmation must be the same`
  def remove_duplicated_messages(errors)
    transform_errors(errors).uniq(&:first)
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
  def transform_errors(errors)
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

  # Used for external inline links in the app.
  # Returns a link with blank target and aria-label.
  #
  # Reference: https://www.w3.org/WAI/GL/wiki/Using_aria-label_for_link_purpose
  def external_link_to(text, url, html_options = {})
    html_options.symbolize_keys!.reverse_merge!(
      target: '_blank',
      class: 'govuk-link',
      rel: 'noopener',
      'aria-label': "#{html_options[:'aria-label'] || text} - #{I18n.t('external_link')}"
    )
    link_to text, url, html_options
  end

  # Creates a back button with link to the dashboard
  def back_link_to_dashboard
    link_to 'Back to dashboard', dashboard_path, class: 'govuk-back-link'
  end

  # Generates a unique link for presentation on the vehicle management page that navigates a user
  # to the VRN entry page in IOD journey.
  def single_vehicle_payment_link
    Rails.configuration.x.payments_ui_url + '/vehicles/enter_details'
  end

  # Returns parsed string, eg. '£10.00'
  def parse_charge(value)
    "£#{format('%<pay>.2f', pay: value.to_f)}"
  end
end
