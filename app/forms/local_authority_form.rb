# frozen_string_literal: true

##
# The form used to validate CAZ selection
#
# ==== Usage
#    form = LocalAuthorityForm.new(caz_id: params['caz_id'])
#    do_something if form.valid?
#
class LocalAuthorityForm < BaseForm
  # Accessor for the LA
  attr_accessor :caz_id

  # Presence validator
  validates :caz_id, presence: { message: I18n.t('la_form.la_missing') }
end
