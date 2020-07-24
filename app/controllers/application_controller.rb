class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_locale, :check_user_activated

  private

  def default_url_options
    {locale: I18n.locale}.merge(super)
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    parsed_locale if I18n.available_locales.map(&:to_s).include? parsed_locale
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:error] = t "global.please_login"
    redirect_to login_url
  end

  def check_user_activated
    return if !logged_in? || user_activated?

    flash[:error] = t "sessions.blocked_account"
    log_out
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "users.not_found"
    redirect_to request.referer || root_url
  end

  def correct_campaign
    @campaign = Campaign.find_by id: params[:campaign_id]
    return if @campaign

    flash[:error] = t "campaigns.not_found"
    redirect_to request.referer || root_url
  end

  def find_campaign
    @campaign = Campaign.find_by id: params[:id]
    return if @campaign

    flash[:error] = t "campaigns.not_found"
    redirect_to request.referer || root_url
  end

  def current_user_admin?
    current_user.admin?
  end

  def check_logged_user_admin
    return if logged_in? && current_user.admin?

    flash[:error] = t "global.no_permission"
    redirect_to request.referer || root_url
  end
end
