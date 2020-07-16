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

  delegate :name, :campaigns, to: :user, prefix: true, allow_nil: true

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

  scope :ordered_campaigns, ->{order donated_amount: :desc}

  scope :filtered_campaigns, (lambda do |keyword|
    if keyword.present?
      where arel_table[:title].lower.matches("%#{keyword.downcase}%")
    end
  end)

  paginates_per Settings.campaign.per_page

  def finished_percentage
    ((donated_amount.to_f / total_amount) * 100).floor
  end
end
