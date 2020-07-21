class Comment < ApplicationRecord
  PERMIT_ATTRIBUTES = :content

  belongs_to :user
  belongs_to :campaign

  delegate :name, to: :user, prefix: true, allow_nil: true

  validates :content,
            presence: true,
            length: {maximum: Settings.donation.max_message_length}

  scope :ordered_comments, ->{order created_at: :desc}

  paginates_per Settings.comment.per_page
end
