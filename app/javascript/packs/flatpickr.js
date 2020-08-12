import flatpickr from 'flatpickr'
import 'flatpickr/dist/flatpickr.min.css'
import 'flatpickr/dist/themes/material_red.css'
import {isElementExist} from './helper'

export function setupFlatpickr() {
  let commonOptions = {
    altInput: true,
    dateFormat: 'Y-m-d'
  }

  if (isElementExist('#campaign_expired_date')) {
    flatpickr('#campaign_expired_date', commonOptions)
  }

  if (isElementExist('#donation_created_date')) {
    flatpickr('#donation_created_date', commonOptions)
  }
}
