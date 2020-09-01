class StaticPagesController < ApplicationController
  def home
    @campaigns = Campaign.not_pending
                         .ordered_campaigns
                         .includes([:user, :image_attachment])
                         .page Settings.campaign.page_show_homepage

    @success_campaigns = Campaign.homepage_success.includes([:user, :image_attachment])
  end

  def about; end

  def pricing; end

  def terms_of_use; end

  def faqs; end
end
