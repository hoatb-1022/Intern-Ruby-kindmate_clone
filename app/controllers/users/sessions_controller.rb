# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :load_user_by_email, only: :create

  def create
    if @user.is_blocked?
      flash[:error] = t ".blocked_account"
      redirect_to login_path
    else
      super
    end
  end

  private

  def load_user_by_email
    @user = User.find_by email: params[:user][:email].downcase
    return if @user

    flash[:error] = t "users.not_found"
    redirect_to request.referer || root_url
  end

  def after_sign_in_path_for _resource
    session[:forwarding_url] || root_url
  end
end
