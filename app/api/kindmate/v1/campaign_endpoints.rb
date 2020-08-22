module Kindmate
  module V1
    class CampaignEndpoints < Grape::API
      version "v1"
      format :json

      desc "Return list of all campaigns"
      get "campaigns" do
        ResponseBuilder.build_success Campaign.all
      end

      desc "Return list of successful campaigns"
      get "campaigns/success" do
        ResponseBuilder.build_success Campaign.homepage_success
      end

      resource "campaigns/:id" do
        before do
          @campaign = Campaign.find_by id: params[:id]
        end

        desc "Return everything of a campaign"
        get do
          if @campaign.present?
            user = @campaign.user
            ResponseBuilder.build_success(
              info: @campaign,
              image: "#{request.url}/image",
              user: {
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                address: user.address,
                description: user.description
              },
              donations: @campaign.donations,
              comment: @campaign.comments
            )
          else
            ResponseBuilder.build_error I18n.t("campaigns.not_found")
          end
        end

        resource :image do
          desc "Return image info of a campaign"
          get do
            if @campaign.try(:image).try(:attached?)
              ResponseBuilder.build_success(
                info: @campaign.image.blob,
                download_url: "#{request.url}/download"
              )
            else
              ResponseBuilder.build_error I18n.t("campaigns.not_found")
            end
          end

          desc "Download image of a campaign"
          get "download" do
            if @campaign.try(:image).try(:attached?)
              content_type "application/octet-stream"
              header["Content-Disposition"] = "attachment; filename=#{@campaign.image.filename}"
              env["api.format"] = :binary
              @campaign.image.blob.download
            else
              ResponseBuilder.build_error I18n.t("campaigns.image_not_found")
            end
          end
        end
      end
    end
  end
end
