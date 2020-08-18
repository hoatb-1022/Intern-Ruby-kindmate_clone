module CampaignsHelper
  VARIANT_STATUSES = {
    pending: "secondary",
    running: "success",
    stopped: "danger"
  }.freeze

  def campaign_main_image campaign
    image_url = "svg/kindmate_blank_bg.svg"
    image_url = campaign.image if campaign.persisted? && campaign.image.attached?

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
      link_text = t "campaigns.do_run"
      link_status = Campaign.statuses[:running]
    when :running
      link_text = t "campaigns.do_stop"
      link_status = Campaign.statuses[:stopped]
    else
      return
    end

    link_to(
      link_text,
      admin_campaign_path(campaign, status: link_status),
      method: "patch",
      data: {confirm: t("global.you_sure?")},
      class: "dropdown-item"
    )
  end

  def campaign_status_badge campaign
    {
      text: t("campaigns.statuses.#{campaign.status}"),
      variant: VARIANT_STATUSES[campaign.status.to_sym]
    }
  end

  def campaign_status_options
    options_for_select(
      Campaign.statuses.map do |k, v|
        [t("campaigns.statuses.#{k.humanize.downcase}"), v]
      end,
      params[:q].try(:[], :status_eq)
    )
  end
end
