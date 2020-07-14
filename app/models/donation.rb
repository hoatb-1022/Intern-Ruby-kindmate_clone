class Donation < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  validates :amount,
            presence: true,
            numericality: {greater_than: Settings.donation.min_amount}
  validates :message, length: {maximum: Settings.donation.max_message_length}
end
