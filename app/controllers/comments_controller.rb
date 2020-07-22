class CommentsController < ApplicationController
  before_action :logged_in_user,
                :correct_campaign,
                only: [:create, :update, :destroy]
  before_action :find_comment, only: [:update, :destroy]

  def create
    @comment = @campaign.comments.build comment_params

    if @comment.save
      refind_comments
    end

    respond_to :js
  end

  def update
    if @comment.update comment_params
      refind_comments
    end

    respond_to :js
  end

  def destroy
    if @comment.destroy
      refind_comments
    end

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
    redirect_to root_url
  end

  def refind_comments
    @comments = @campaign.comments
                         .ordered_comments
                         .includes(:user)
                         .page params[:page]
  end
end
