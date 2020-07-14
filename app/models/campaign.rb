class Campaign < ApplicationRecord
  PERMIT_ATTRIBUTES =
    %i(
      title
      content
      description
      image
      embedded_link
      total_amount
      expired_at
    ).freeze

  belongs_to :user

  has_one_attached :image

  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, :expired_at, presence: true
  validates :title,
            :description,
            presence: true,
            length: {maximum: Settings.campaign.title_max_length}
  validates :total_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: Settings.campaign.min_total_amount
            }
  validates :image,
            presence: true,
            content_type: {
              in: Settings.campaign.format_image_accept,
              message: I18n.t("campaigns.valid_image_format!")
            },
            size: {
              less_than: Settings.campaign.max_image_size,
              message: I18n.t("campaigns.valid_image_size!")
            }
end
