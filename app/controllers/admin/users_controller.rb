class Admin::UsersController < AdminController
  before_action :logged_in_user,
                :check_logged_user_admin,
                only: [:index, :update]
  before_action :filter_user, only: :index
  before_action :find_user, only: :update

  def index
    @users = @users.ordered_users.page params[:page]
  end

  def update
    if @user.update is_blocked: params[:status] == Settings.user.is_blocked
      flash[:success] = t ".success_change_status"
    else
      flash[:error] = t ".failed_change_status"
    end

    redirect_to request.referer
  end

  private

  def filter_user
    @users = User.filter_by_name(params[:name])
                 .filter_by_email(params[:email])
                 .filter_by_phone(params[:phone])
                 .filter_by_address(params[:address])
                 .filter_by_desc(params[:desc])
                 .filter_by_status(params[:status])
  end
end
