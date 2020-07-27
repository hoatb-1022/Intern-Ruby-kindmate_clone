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

  scope :ordered_and_paginated, ->(page){ordered_campaigns.page page}

  scope :ordered_campaigns_by_donated, ->{order donated_amount: :desc}

  scope :filter_by_title, ->(value){filter_by_string_attr :title, value}

  scope :filter_by_desc, ->(value){filter_by_string_attr :description, value}

  scope :filter_by_status, ->(value){filter_by_number_attr :status, value}

  scope :filter_by_creator, (lambda do |creator|
    return if creator.blank?

    where User.arel_table[:name].lower.matches("%#{creator.downcase}%")
  end)

  scope :filter_by_title_or_desc, (lambda do |keyword|
    filter_by_title(keyword).or(filter_by_desc(keyword))
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
