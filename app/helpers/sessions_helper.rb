module SessionsHelper
  def current_user? user
    user == current_user
  end

  def current_user_or_admin? user
    current_user?(user) || current_user.admin?
  end

  def user_activated?
    !current_user&.is_blocked?
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
