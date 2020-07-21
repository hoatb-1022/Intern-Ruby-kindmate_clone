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

  enum status: {pending: 0, running: 1, stopped: 2}

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

  scope :ordered_campaigns, ->{order created_at: :desc}

  scope :ordered_campaigns_by_donated, ->{order donated_amount: :desc}

  scope :filtered_campaigns, (lambda do |keyword|
    if keyword.present?
      where arel_table[:title].lower.matches(
        "%#{keyword.downcase}%"
      )
    end
  end)

  scope :filter_by_title, (lambda do |title|
    if title.present?
      where arel_table[:title].lower.matches(
        "%#{title.downcase}%"
      )
    end
  end)

  scope :filter_by_desc, (lambda do |desc|
    if desc.present?
      where arel_table[:desc].lower.matches(
        "%#{desc.downcase}%"
      )
    end
  end)

  scope :filter_by_status, (lambda do |status|
    if status.present?
      where arel_table[:status].eq(
        status
      )
    end
  end)

  scope :filter_by_creator, (lambda do |creator|
    if creator.present?
      where User.arel_table[:name].lower.matches(
        "%#{creator.downcase}%"
      )
    end
  end)

  paginates_per Settings.campaign.per_page

  def finished_percentage
    percent = ((donated_amount.to_f / total_amount) * 100).floor
    percent.negative? ? 0 : percent
  end

  def bound_percent_style
    finished_percentage <= 100 ? finished_percentage : 100
  end
end
