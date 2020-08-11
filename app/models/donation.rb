class Donation < ApplicationRecord
  PERMIT_ATTRIBUTES =
    %i(
      amount
      message
      payment_type
      payment_code
    ).freeze

  enum payment_type: {transfer: 0, payment: 1, cash: 2}

  include Notifier
  include Rails.application.routes.url_helpers

  delegate :name, to: :user, prefix: true, allow_nil: true

  belongs_to :user
  belongs_to :campaign

  validates :payment_type,
            presence: true,
            inclusion: {in: Donation.payment_types.keys}
  validates :amount,
            presence: true,
            numericality: {greater_than: Settings.donation.min_amount}
  validates :message, length: {maximum: Settings.donation.max_message_length}

  after_save :update_campaign
  after_create :notify_new_donation

  scope :ordered_donations, ->{order created_at: :desc}
  scope :by_user_distinct, ->{select("distinct(user_id)")}

  paginates_per Settings.donation.per_page

  class << self
    def generate_payment_code campaign_id
      "KM#{campaign_id.to_s + Time.zone.now.strftime('%Y%m%d%H%M%S')}"
    end
  end

  def update_campaign
    campaign.update donated_amount: (campaign.donated_amount + amount)
  end

  def notify_new_donation
    notify_to_user(
      campaign.user_id,
      I18n.t("notify.donation.new"),
      I18n.t("notify.donation.created"),
      campaign_url(id: campaign.id)
    )
  end
end
