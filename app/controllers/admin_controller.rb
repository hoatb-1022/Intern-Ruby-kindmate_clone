class AdminController < ApplicationController
  layout "admin"

  before_action :check_current_user_admin

  private

  def check_current_user_admin
    return if user_signed_in? && current_user_admin?

    flash[:error] = t "global.no_permission"
    redirect_to request.referer || root_url
  end
end
