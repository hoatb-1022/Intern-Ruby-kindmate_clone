class Admin::UsersController < AdminController
  before_action :find_user, only: :update

  def index
    @query = User.ransack params[:q]
    @users = @query.result.ordered_users.page params[:page]
  end

  def update
    if @user.update is_blocked: params[:status] == Settings.user.is_blocked
      flash[:success] = t ".success_change_status"
    else
      flash[:error] = t ".failed_change_status"
    end

    redirect_to request.referer
  end
end
