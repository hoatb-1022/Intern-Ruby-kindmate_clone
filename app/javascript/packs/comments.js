export function setupCommentEdit() {
  $('body').on('click', '.card-comment .edit-comment-item', function (event) {
    event.preventDefault()

    let commentId = this.getAttribute('target-id')
    let editCommentFormEl = $(`#edit_comment_${commentId}`)
    let commentContentEl = $(`#comment-content-${commentId}`)

    editCommentFormEl.removeClass('d-none')
    commentContentEl.addClass('d-none')

    $(`#edit_comment_${commentId} .submit-comment .btn-cancel-edit`).click(function () {
      editCommentFormEl.addClass('d-none')
      commentContentEl.removeClass('d-none')

      let commentTextAreaEl = $(`#edit_comment_${commentId} .edit_comment .form-comment textarea`)
      commentTextAreaEl.val(commentTextAreaEl.attr('origin-val'))
    })
  })
}

export function setupCommentReplyToggle() {
  $('body').on('click', '.card-comment .reply-comment-item', function (event) {
    event.preventDefault()

    let commentId = this.getAttribute('target-id')
    $(`#comment_${commentId}_reply`).toggleClass('d-none')
  })
}
