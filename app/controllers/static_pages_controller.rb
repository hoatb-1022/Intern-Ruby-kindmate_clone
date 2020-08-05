class StaticPagesController < ApplicationController
  def home
    @campaigns = Campaign.not_pending
                         .ordered_campaigns
                         .includes(:user)
                         .page Settings.campaign.page_show_homepage

    @success_campaigns = Campaign.ordered_campaigns_by_donated.limit(
      Settings.campaign.success_show_homepage
    )
  end

  def about; end

  def pricing; end

  def terms_of_use; end

  def faqs; end
end
