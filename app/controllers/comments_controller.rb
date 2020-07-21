class CommentsController < ApplicationController
  before_action :logged_in_user,
                :correct_campaign,
                only: [:create, :update, :destroy]
  before_action :find_comment, only: [:update, :destroy]

  def create
    @comment = @campaign.comments.build comment_params

    if @comment.save
      flash[:success] = t ".success_commented"
    else
      flash[:error] = t ".failed_commented"
    end

    redirect_to @campaign, anchor: "campaign-comments"
  end

  def update
    if @comment.update comment_params
      flash[:success] = t ".success_updated"
    else
      flash[:error] = t ".failed_updated"
    end

    redirect_to @campaign, anchor: "campaign-comments"
  end

  def destroy
    if @comment.destroy
      flash[:success] = t ".success_deleted"
    else
      flash[:error] = t ".failed_deleted"
    end

    redirect_to @campaign, anchor: "campaign-comments"
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
end
