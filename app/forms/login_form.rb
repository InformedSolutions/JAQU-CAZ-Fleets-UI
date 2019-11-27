class LoginForm
  include ActiveModel::Validations

  validates :email, presence: { message: I18n.t('login_form.email_missing') }
  validates :password, presence: { message: I18n.t('login_form.password_missing') }
  validates :email, format: {
    with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: I18n.t('login_form.invalid_email')
  }

  def initialize(email, password)
    @email = email
    @password = password
  end

  private

  attr_reader :email, :password
end
