// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

require('jquery')
require('bootstrap')
//= require_tree .

import toastr from 'toastr'

window.toastr = toastr

import ApexCharts from 'apexcharts'

window.ApexCharts = ApexCharts

import '@fortawesome/fontawesome-free/js/all'
import {setupUserAvatar} from './users'
import {
  setupCampaignImage,
  setupContentToggle,
  setupSeeCreatorInfoLink,
  setupFacebookSharingBtn
} from './campaigns'
import {setupPaymentRadio} from './donations'
import {setupCommentEdit} from './comments'
import {setupTagButtons} from './tags'
import {setupNavbarItemMatchRoute} from './router'
import {setupFlatpickr} from './flatpickr'
import {isElementExist} from './helper'

$(document).on('turbolinks:load', function () {
  setupUserAvatar()
  setupCampaignImage()
  setupContentToggle()
  setupSeeCreatorInfoLink()
  setupFacebookSharingBtn()
  setupPaymentRadio()
  setupCommentEdit()
  setupTagButtons()
  setupFlatpickr()
  setupNavbarItemMatchRoute()

  if (isElementExist('#navbarMapToggle')) {
    $('#navbarMapToggle').click(function (e) {
      $('#formUserMap').toggleClass('hide')
    })
  }
})

Notification.requestPermission().then(function (result) {
})

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
