function previewCampaignImage(image) {
  $('#campaign-image').attr('src', URL.createObjectURL(image))
}

function checkCampaignImageSize(image) {
  let size_in_megabytes = image.size / 1024 / 1024
  return size_in_megabytes <= 5
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
