import consumer from './consumer'

consumer.subscriptions.create('NotificationChannel', {
  connected() {},

  disconnected() {},

  received(data) {
    if (Notification.permission === 'granted') {
      let noti = new Notification(data.title, {body: data.body})
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
