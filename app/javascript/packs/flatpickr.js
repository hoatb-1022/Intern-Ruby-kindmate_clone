import flatpickr from 'flatpickr'
import 'flatpickr/dist/flatpickr.min.css'
import 'flatpickr/dist/themes/material_red.css'
import {isElementExist} from './helper'

export function setupFlatpickr() {
  if (isElementExist('#campaign_expired_date')) {
    flatpickr('#campaign_expired_date', {
      altInput: true,
      dateFormat: 'Y-m-d'
    })
  }
}
