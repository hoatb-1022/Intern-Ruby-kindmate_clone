import consumer from './consumer'

consumer.subscriptions.create('NotificationChannel', {
  connected() {},

  disconnected() {},

  received(data) {
    $('.no-notifications-text').remove()
    $('#notificationDropdownBox').prepend(data.html)
    $('#notification-render').prepend(data.html)

    let notiCountBadge = $('#notificationsNewCount')
    notiCountBadge.removeClass('d-none')
    notiCountBadge.html(data.not_view_count)

    if (Notification.permission === 'granted') {
      let noti = new Notification(I18n.t(data.title), {body: I18n.t(data.body)})
      noti.addEventListener('click', (event) => {
        event.preventDefault()
        noti.close()
        setTimeout(() => {
          if (data.target) {
            window.location.href = data.target
          } else {
            location.reload()
          }
        }, 250)
      })
    }
  }
})
