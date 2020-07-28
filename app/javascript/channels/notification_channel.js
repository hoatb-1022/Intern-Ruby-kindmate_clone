import consumer from './consumer'

consumer.subscriptions.create('NotificationChannel', {
  connected() {
    console.log('Connected')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('Disconnected')
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
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
