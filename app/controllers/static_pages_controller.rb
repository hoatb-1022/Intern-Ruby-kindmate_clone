class StaticPagesController < ApplicationController
  def home
    @campaigns = Campaign.ordered_campaigns.page(
      Settings.campaign.page_show_homepage
    )
  end

  def about; end

  def pricing; end

  def terms_of_use; end

  def faqs; end
end
