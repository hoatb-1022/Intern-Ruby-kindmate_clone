module NotificationsHelper
  def current_noti
    current_user.notifications.ordered_notifications
  end

  def current_nviewed_noti
    current_noti.not_viewed_notifications
  end

  def nav_current_noti
    current_noti.nav_dropdown_notifications
  end
end
