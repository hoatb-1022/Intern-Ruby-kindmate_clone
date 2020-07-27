function setupAddTagBtn() {
  $('form').on('click', '.btn-add-tags', function (event) {
    let time = new Date().getTime()
    let regexp = new RegExp($(this).data('id'), 'g')
    $('.campaign-tags').append($(this).data('fields').replace(regexp, time))
    return event.preventDefault()
  })
}

function setupDeleteTagBtn() {
  $('form').on('click', '.tag-form .btn-remove-tag', function (event) {
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.tag-form').hide()
    return event.preventDefault()
  })
}

export function setupTagButtons() {
  setupAddTagBtn()
  setupDeleteTagBtn()
}
