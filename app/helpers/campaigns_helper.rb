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
        class: "rounded embed-responsive-item"
      )
    end
  end

  def campaign_change_status_link campaign
    case campaign.status.to_sym
    when :pending
      link_to(
        "Run campaign",
        admin_campaign_path(campaign, status: 1),
        method: "patch",
        class: "dropdown-item"
      )
    when :running
      link_to(
        "Stop campaign",
        admin_campaign_path(campaign, status: 2),
        method: "patch",
        class: "dropdown-item"
      )
    else
      ""
    end
  end

  def campaign_status_badge campaign
    case campaign.status.to_sym
    when :pending
      {text: "Pending", variant: "secondary"}
    when :running
      {text: "Running", variant: "success"}
    else
      {text: "Stopped", variant: "danger"}
    end
  end
end
