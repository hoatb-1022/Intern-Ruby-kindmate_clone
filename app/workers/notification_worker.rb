class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform notification_id
    @notification = Notification.find_by id: notification_id
    return unless @notification

    user = @notification.user
    user_id = user.id
    title = @notification.title
    body = @notification.body
    target = @notification.target
    html = ApplicationController.render(
      partial: "notifications/notification",
      locals: {notification: @notification},
      formats: [:html]
    )
    not_view_count = user.notifications.not_viewed_notifications.size

    ActionCable.server.broadcast(
      "notifications_#{user_id}",
      title: title,
      body: body,
      target: target,
      html: html,
      not_view_count: not_view_count
    )
  end
end
