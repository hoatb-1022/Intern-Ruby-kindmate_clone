export function setupCommentEdit() {
  $('.card-comment .edit-comment-item').click(function (event) {
    event.preventDefault()

    let commentId = this.getAttribute('target-id')
    let editCommentFormEl = $(`#comment_${commentId} .edit_comment`)
    let commentContentEl = $(`#comment_${commentId} .comment-content`)

    editCommentFormEl.removeClass('d-none')
    commentContentEl.addClass('d-none')

    $(`#comment_${commentId} .submit-comment .btn-cancel-edit`).click(function () {
      editCommentFormEl.addClass('d-none')
      commentContentEl.removeClass('d-none')

      let commentTextAreaEl = $(`#comment_${commentId} .edit_comment .form-comment textarea`)
      commentTextAreaEl.val(commentTextAreaEl.attr('origin-val'))
    })
  })
}
