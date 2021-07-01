# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Class used to validate data submitted manage fleet page to choose edit option.
  #
  # ==== Usages
  #    form = UsersManagement::EditFleetForm.new(edit_option: 'add_single')
  #    redirect_to path if form.valid?
  #
  class EditFleetForm < BaseForm
    validates :edit_option, inclusion: {
      in: %w[add_single add_multiple remove], message: I18n.t('edit_fleet_form.errors.missing_answer')
    }

    ##
    # Initializes the form
    #
    # ==== Attributes
    # * +edit_option+ - option selced by the user
    #
    def initialize(edit_option)
      @edit_option = edit_option
    end

    private

    # Attributes
    attr_accessor :edit_option
  end
end
