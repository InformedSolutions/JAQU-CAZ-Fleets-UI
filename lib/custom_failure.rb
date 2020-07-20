# frozen_string_literal: true

# Class used to define custom failure of login process
# Is called when authentication is unsuccessful
class CustomFailure < Devise::FailureApp
  def redirect_url
    if confirmation_referer?
      set_up_confirmation_users_path
    else
      new_user_session_path
    end
  end

  def respond
    flash[:errors] = format_warden_sign_in_errors

    if http_auth?
      http_auth
    elsif !confirmation_referer? && warden_options[:recall]
      recall
    else
      redirect
    end
  end

  private

  def format_warden_sign_in_errors
    {
      base: warden.errors[:base],
      email: warden.errors[:email],
      password: warden.errors[:password]
    }
  end

  def confirmation_referer?
    request.referer&.include?(set_up_confirmation_users_path)
  end
end
