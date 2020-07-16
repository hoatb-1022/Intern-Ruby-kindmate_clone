module CampaignsHelper
  def campaign_main_image campaign
    image_url = "svg/kindmate_blank_bg.svg"
    image_url = campaign.image if campaign.image.attached?

    image_tag image_url, id: "campaign-image", class: "embed-responsive-item"
  end
end
