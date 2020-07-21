module CampaignsHelper
  def campaign_main_image campaign
    image_url = "svg/kindmate_blank_bg.svg"
    image_url = campaign.image if campaign.image.attached?

    image_tag image_url, id: "campaign-image", class: "embed-responsive-item"
  end

  def campaign_main_title_frame campaign
    if campaign.embedded_link.present?
      sanitize(
        campaign.embedded_link,
        tags: %w(iframe),
        attributes: %w(src source width height)
      )
    elsif campaign.image.attached?
      image_tag(
        campaign.image,
        class: "has-border-radius embed-responsive-item"
      )
    end
  end
end
