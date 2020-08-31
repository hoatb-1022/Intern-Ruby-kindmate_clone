class Comment < ApplicationRecord
  PERMIT_ATTRIBUTES = :content

  include Rails.application.routes.url_helpers

  acts_as_paranoid

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, dependent: :destroy, as: :commentable

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
    body_message = if commentable == Campaign.name
                     "notifications.comment.main_created"
                   else
                     "notifications.comment.reply_created"
                   end

    notification = commentable.user.notifications.create(
      title: "notifications.comment.new",
      body: body_message,
      target: commentable == Campaign.name ? campaign_url(id: commentable.id, slug: commentable.slug) : "#"
    )
    NotificationWorker.perform_async notification.id if notification.persisted?
  end
end
