class Comment < ApplicationRecord
  PERMIT_ATTRIBUTES = :content

  include Rails.application.routes.url_helpers

  acts_as_paranoid

  belongs_to :user
  belongs_to :campaign

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :id, to: :campaign, prefix: true, allow_nil: true

  validates :content,
            presence: true,
            length: {maximum: Settings.donation.max_message_length}

  after_create :notify_new_comment

  scope :ordered_comments, ->{order created_at: :desc}

  scope :ordered_and_paginated, ->(page){ordered_comments.page page}

  paginates_per Settings.comment.per_page

  private

  def notify_new_comment
    notification = campaign.user.notifications.create(
      title: "notifications.comment.new",
      body: "notifications.comment.created",
      target: campaign_url(id: campaign.id, slug: campaign.slug)
    )
    NotificationWorker.perform_async notification.id if notification.persisted?
  end
end
