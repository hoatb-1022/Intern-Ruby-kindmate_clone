class SessionsController < ApplicationController
  before_action :find_user_by_email, only: :create

  def new
    redirect_to current_user if logged_in?
  end

  def create
    if @user&.authenticate params[:session][:password]
      if @user.activated?
        login_checked_user
      else
        flash[:warning] = t ".check_active_mail"
        redirect_to root_url
      end
    else
      flash.now[:error] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
  end

  def login_checked_user
    log_in @user

    if params[:session][:remember_me] == Settings.session.remember_me?
      remember(@user)
    else
      forget(@user)
    end

    redirect_back_or @user
  end
end
