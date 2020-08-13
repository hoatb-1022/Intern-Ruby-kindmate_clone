module SessionsHelper
  def current_user? user
    user == current_user
  end

  def current_user_or_admin? user
    current_user?(user) || current_user_admin?
  end

  def current_user_admin?
    current_user&.has_role? :admin
  end

  def user_activated?
    !current_user&.is_blocked?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
