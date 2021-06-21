# frozen_string_literal: true

##
# The form used to validate vrn in VehiclesController.submit_details
#
class VrnForm < BaseForm
  # Submitted vehicle registration number
  attr_reader :vrn

  validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }
  validates :vrn, length: {
    minimum: 2,
    maximum: 7,
    too_short: I18n.t('vrn_form.errors.vrn_too_short'),
    too_long: I18n.t('vrn_form.errors.vrn_too_long')
  }
  validate :validate_format

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn&.upcase&.delete(' ')&.gsub(/^0+/, '')
  end

  private

  # Validates format against possible ones
  def validate_format
    return if FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn).present?
    end

    errors.add(:vrn, I18n.t('vrn_form.errors.vrn_invalid'))
  end

  # Possible vrn formats
  FORMAT_REGEXPS = [
    /^[A-Za-z]{1,2}[0-9]{1,4}$/,
    /^[A-Za-z]{3}[0-9]{1,3}$/,
    /^[1-9][0-9]{0,2}[A-Za-z]{3}$/,
    /^[1-9][0-9]{0,3}[A-Za-z]{1,2}$/,
    /^[A-Za-z]{3}[0-9]{1,3}[A-Za-z]$/,
    /^[A-Za-z][0-9]{1,3}[A-Za-z]{3}$/,
    /^[A-Za-z]{2}[0-9]{2}[A-Za-z]{3}$/,
    /^[A-Za-z]{3}[0-9]{4}$/
  ].freeze
end
