function previewCampaignImage(image) {
  $('#campaign-image').attr('src', URL.createObjectURL(image))
}

function checkCampaignImageSize(image) {
  let size_in_megabytes = image.size / 1024 / 1024
  return size_in_megabytes <= 5
}

export function setupContentToggle() {
  let toggleBtn = $('#toggle-campaign-content')
  toggleBtn.click(function () {
    let campaignContentEl = $('#campaign-content')
    campaignContentEl.toggleClass('full-view')

    if (campaignContentEl.hasClass('full-view')) {
      toggleBtn.html(I18n.t('campaigns.show.show_less'))
    } else {
      toggleBtn.html(I18n.t('campaigns.show.show_more'))
    }
  })
}

export function setupFacebookSharingBtn() {
  $('a.share').click(function (event) {
    event.preventDefault()

    let $link = $(this)
    let href = $link.attr('href')
    let network = $link.attr('data-network')
    let networks = {
      facebook: {width: 600, height: 300}
    }
    let popup = function (network) {
      let options = 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,'
      window.open(href, '', options + 'height=' + networks[network].height + ',width=' + networks[network].width)
    }
    popup(network)
  })
}

export function setupCampaignImage() {
  $('#campaign_image').on('change', function (event) {
    let image = event.target.files[0]
    if (checkCampaignImageSize(image)) {
      previewCampaignImage(image)
    } else {
      alert(I18n.t('global.alert_size_exceeded', {maximum: 5}))
    }
  })
}

export function setupSeeCreatorInfoLink() {
  $('#see-creator-info-link').click(function (event) {
    event.preventDefault()
    $('#pills-creator-tab')[0].click()
  })
}
