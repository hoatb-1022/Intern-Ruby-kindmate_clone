# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_auth_user Settings.oauth_kinds.facebook
  end

  def google_oauth2
    handle_auth_user Settings.oauth_kinds.google
  end

  def failure
    redirect_to login_path
  end

  private

  def handle_auth_user kind
    @user = User.from_omniauth auth
    if @user.persisted?
      sign_out_all_scopes
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: kind, reason: "#{auth.info.email} is not authorized."
      redirect_to signup_path
    end
  end

  def auth
    request.env["omniauth.auth"]
  end
end
