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

export function setupCampaignContent() {
  setupContentToggle()
  setupCommentScroll()
}
