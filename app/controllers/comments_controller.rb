class CommentsController < ApplicationController
  before_action :check_logged_in_user,
                :find_campaign,
                :find_commentable,
                only: [:create, :update, :destroy]
  before_action :find_comment, only: [:update, :destroy]

  def create
    @comment = @commentable.comments.build comment_params
    refind_comments if @comment.save

    respond_to :js
  end

  def update
    refind_comments if @comment.update comment_params

    respond_to :js
  end

  def destroy
    refind_comments if @comment.destroy

    respond_to :js
  end

  private

  def comment_params
    params.require(:comment).permit(
      Comment::PERMIT_ATTRIBUTES
    ).merge user_id: current_user.id
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment

    flash[:error] = t ".not_found"
    redirect_to not_found_url
  end

  def refind_comments
    @comments = @campaign.comments
                         .ordered_comments
                         .includes(:user)
                         .page params[:page]
  end

  def find_commentable
    @commentable = Comment.find_by id: params[:comment_id]
    @commentable ||= @campaign
    return if @commentable

    flash[:error] = t ".p_not_found"
    redirect_to not_found_url
  end
end
