module Kindmate
  module V1
    class UserEndpoints < Grape::API
      include Defaults

      desc "Login with email and password"
      params do
        requires :email, type: String, desc: "user's email"
        requires :password, type: String, desc: "user's password"
      end
      post "login" do
        user = User.find_by email: params[:email]
        if user.present?
          if user.valid_password? params[:password]
            jwt = User.generate_jwt_token user
            ResponseBuilder.build_success UserSerializer.new(user, params: {token: jwt})
          else
            ResponseBuilder.build_error I18n.t("api.wrong_login_info")
          end
        else
          ResponseBuilder.build_error I18n.t("users.not_found")
        end
      end

      resource :users do
        desc "Return list of all users"
        get do
          ResponseBuilder.build_success UserSerializer.new(User.all)
        end

        desc "Return details of a user"
        get ":id" do
          user = User.find_by id: params[:id]
          if user.present?
            ResponseBuilder.build_success UserSerializer.new(user)
          else
            ResponseBuilder.build_error I18n.t("users.not_found")
          end
        end

        desc "Return details of a user"
        get ":id/campaigns" do
          user = User.find_by id: params[:id]
          if user.present?
            ResponseBuilder.build_success CampaignSerializer.new(user.campaigns)
          else
            ResponseBuilder.build_error I18n.t("users.not_found")
          end
        end
      end
    end
  end
end
