module Kindmate
  module V1
    class UserEndpoints < Grape::API
      version "v1"
      format :json

      resource :users do
        desc "Return list of all users"
        get do
          ResponseBuilder.build_success UserSerializer.new(User.all)
        end

        desc "Return details of a user"
        get ":id" do
          @user = User.find_by id: params[:id]
          if @user.present?
            ResponseBuilder.build_success UserSerializer.new(@user)
          else
            ResponseBuilder.build_error I18n.t("users.not_found")
          end
        end

        desc "Return details of a user"
        get ":id/campaigns" do
          @user = User.find_by id: params[:id]
          if @user.present?
            ResponseBuilder.build_success CampaignSerializer.new(@user.campaigns)
          else
            ResponseBuilder.build_error I18n.t("users.not_found")
          end
        end
      end
    end
  end
end
