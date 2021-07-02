# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # This class is used to validate user data filled in +app/views/users_management/users/new.html.haml+.
  class AddUserForm < NewUserBaseForm
    # Deny list characters
    DENY_LIST_CHARACTERS = /([%<>:`&])/u

    # validates name attribute to presence
    validates :name, presence: { message: I18n.t('add_new_user_form.errors.name_missing') }
    # validates email attribute to presence
    validates :email, presence: { message: I18n.t('add_new_user_form.errors.email_missing') }
    # validates email format
    validates :email, format: {
      with: EMAIL_FORMAT,
      message: I18n.t('add_new_user_form.errors.email_invalid_format')
    }, allow_blank: true
    # validates +email+ against duplication
    validate :email_not_duplicated, if: -> { email.present? }
    # validates +name+ against deny list characters
    validate :allowed_name_characters, if: -> { name.present? }

    ##
    # Initializes the form
    #
    # ==== Attributes
    # * +account_id+ - uuid, the id of the administrator user account
    # + +new_user+ - array, user params: email and name
    #
    def initialize(account_id:, new_user:)
      @account_id = account_id
      @name = new_user['name']
      @email = new_user['email']
    end

    private

    # Validates user's name against deny list characters
    def allowed_name_characters
      return if name.match(DENY_LIST_CHARACTERS).blank?

      errors.add(:name, I18n.t('add_new_user_form.errors.name_invalid'))
    end
  end
end
