module Notifier
  extend ActiveSupport::Concern

  def notify_to_user id, title, body, target
    ActionCable.server.broadcast "notifications_#{id}", {
      title: title,
      body: body,
      target: target
    }
  end

  def notify_to_admin title, body, target
    admin_id = User.admin[0].id
    notify_to_user admin_id, title, body, target
  end
end
