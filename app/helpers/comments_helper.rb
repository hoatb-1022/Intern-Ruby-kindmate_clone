module CommentsHelper
  def comment_delete_path comment, campaign
    if comment.commentable_type == Campaign.name
      [comment.commentable, comment]
    else
      [campaign, comment.commentable, comment]
    end
  end
end
