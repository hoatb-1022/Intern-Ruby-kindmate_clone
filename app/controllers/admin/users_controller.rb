class Admin::UsersController < AdminController
  before_action :logged_in_user,
                :check_current_user_admin,
                only: [:index, :update]
  before_action :filter_user, :order_paginate_user, only: :index
  before_action :find_user, only: :update

  def index; end

  def update
    @user.update is_blocked: params[:status] == "1"
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

  def order_paginate_user
    @user = @user.ordered_users.page params[:page]
  end
end
