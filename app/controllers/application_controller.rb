class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale, :check_user_activated

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html do
        check_logged_in_user
        redirect_to(request.referer || root_url, alert: t("global.no_permission"))
      end
      format.js{render nothing: true, status: :not_found}
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::PERMIT_ATTRIBUTES)
  end

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

  def check_logged_in_user
    return if user_signed_in?

    store_location
    flash[:error] = t "global.please_login"
    redirect_to login_url
  end

  def check_user_activated
    return if !user_signed_in? || user_activated?

    flash[:error] = t "users.sessions.blocked_account"
    sign_out current_user
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
end
