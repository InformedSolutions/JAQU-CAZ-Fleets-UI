# frozen_string_literal: true

##
# The form used to validate CAZ selection
#
# ==== Usage
#    form = LocalAuthorityForm.new(authority: params['local-authority'])
#    do_something if form.valid?
#
class LocalAuthorityForm < BaseForm
  # Accessor for the LA
  attr_accessor :authority

  # Presence validator
  validates :authority, presence: { message: I18n.t('la_form.la_missing') }
end
