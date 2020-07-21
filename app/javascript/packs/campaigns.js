function previewCampaignImage(image) {
  $('#campaign-image').attr('src', URL.createObjectURL(image))
}

function checkCampaignImageSize(image) {
  let size_in_megabytes = image.size / 1024 / 1024
  return size_in_megabytes <= 5
}

function setupContentToggle() {
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

function setupCommentScroll() {
  $('#pills-comments-tab').click(function () {
    $('#campaign-comments')[0].scrollIntoView()
  })
}

export function setupCampaignImage() {
  $('#campaign_image').on('change', function (event) {
    let image = event.target.files[0]
    if (checkCampaignImageSize(image)) {
      previewCampaignImage(image)
    } else {
      alert(I18n.t('campaigns.alert_size_exceeded'))
    }
  })
}

export function setupCampaignContent() {
  setupContentToggle()
  setupCommentScroll()
}
