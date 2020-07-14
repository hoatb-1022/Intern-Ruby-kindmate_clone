import flatpickr from 'flatpickr'
import 'flatpickr/dist/flatpickr.min.css'
import 'flatpickr/dist/themes/material_red.css'

export function setupFlatpickr() {
  flatpickr('#campaign_expired_date', {
    altInput: true,
    dateFormat: 'Y-m-d'
  })
}
