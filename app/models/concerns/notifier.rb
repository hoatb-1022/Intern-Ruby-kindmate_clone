module Notifier
  extend ActiveSupport::Concern

  def notify_to_user id, title, body, target
    ActionCable.server.broadcast "notifications_#{id}", title: title, body: body, target: target
  end

  def notify_to_admin title, body, target
    User.admin.each do |admin|
      notify_to_user admin.id, title, body, target
    end
  end
end
