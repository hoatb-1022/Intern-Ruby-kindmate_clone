class Notification < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(title body target).freeze

  acts_as_paranoid

  belongs_to :user

  validates :title,
            presence: true,
            length: {maximum: Settings.notification.max_title_length}
  validates :body,
            presence: true,
            length: {maximum: Settings.notification.max_body_length}
  validates :target,
            presence: true

  scope :ordered_notifications, ->{order created_at: :desc}

  scope :ordered_and_paginated, ->(page){ordered_notifications.page page}

  scope :not_viewed_notifications, ->{where arel_table[:is_viewed].eq false}

  scope :nav_dropdown_notifications, ->{ordered_notifications.limit Settings.notification.show_nav_dropdown}

  paginates_per Settings.notification.per_page
end
