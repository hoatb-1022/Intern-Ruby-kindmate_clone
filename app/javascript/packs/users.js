function previewUserAvatar(avatar) {
  $('#user-avatar').attr('src', URL.createObjectURL(avatar))
}

function checkUserAvatarSize(avatar) {
  let size_in_megabytes = avatar.size / 1024 / 1024
  return size_in_megabytes <= 3
}

export function setupUserAvatar() {
  $('#user_avatar').on('change', function (event) {
    let avatar = event.target.files[0]
    if (checkUserAvatarSize(avatar)) {
      previewUserAvatar(avatar)
    } else {
      alert(I18n.t('global.alert_size_exceeded', {maximum: 3}))
    }
  })
}
