class Comment < ApplicationRecord
  PERMIT_ATTRIBUTES = :content

  include Notifier
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :campaign

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :id, to: :campaign, prefix: true, allow_nil: true

  validates :content,
            presence: true,
            length: {maximum: Settings.donation.max_message_length}

  after_create :notify_new_comment

  scope :ordered_comments, ->{order created_at: :desc}

  paginates_per Settings.comment.per_page

  private

  def notify_new_comment
    notify_to_user(
      campaign.user_id,
      I18n.t("notify.comment.new"),
      I18n.t("notify.comment.created"),
      campaign_url(id: campaign.id)
    )
  end
end
