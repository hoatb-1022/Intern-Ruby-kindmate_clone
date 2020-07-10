class Campaign < ApplicationRecord
  belongs_to :user

  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, :expired_at, presence: true
  validates :title,
            presence: true,
            length: {maximum: Settings.campaign.title_max_length}
  validates :total_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: Settings.campaign.min_total_amount
            }
end
