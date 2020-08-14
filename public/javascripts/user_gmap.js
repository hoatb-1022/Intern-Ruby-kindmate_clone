const VIETNAM_COORDS = {
  lat: 14.053906,
  lng: 108.283801
}

function initMap() {
  window.map = new google.maps.Map(document.getElementById('userAddressMap'), {
    zoom: 6,
    center: VIETNAM_COORDS
  })

  window.marker = new google.maps.Marker({
    position: VIETNAM_COORDS,
    map: window.map,
    draggable: true,
    title: I18n.t('global.you_are_here')
  })

  window.marker.addListener('click', () => {
    window.map.setZoom(16)
    window.map.setCenter(window.marker.getPosition())
  })

  window.marker.addListener('dragend', () => {
    let newPosition = window.marker.getPosition()
    window.map.setCenter(newPosition)
    evalUserCoords(newPosition)
  })

  window.mapAutoComplete = new google.maps.places.Autocomplete(document.getElementById('user_address'))
  window.mapAutoComplete.addListener('place_changed', onPlaceChanged)

  getLocation()
}

function onPlaceChanged() {
  let place = window.mapAutoComplete.getPlace()
  if (place.geometry) {
    putMarkerOnPosition(place.geometry.location)
  }
}

function getLocation() {
  let latlng = {
    lat: $('#user_latitude').val(),
    lng: $('#user_longitude').val()
  }

  if (latlng.lat !== '' && latlng.lng !== '') {
    latlng.lat = Number(latlng.lat)
    latlng.lng = Number(latlng.lng)
    putMarkerOnPosition(latlng)
  } else {
    latlng = VIETNAM_COORDS
    putMarkerOnPosition(latlng)

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function (position) {
        latlng = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        }

        putMarkerOnPosition(latlng)
      })
    }
  }
}

function putMarkerOnPosition(position) {
  window.marker.setPosition(position)
  window.map.panTo(position)
  evalUserCoords(position)
}

function evalUserCoords(position) {
  $('#user_latitude').val(position.lat)
  $('#user_longitude').val(position.lng)
}
