class User < ApplicationRecord
  has_many :campaigns, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :email,
            presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: URI::MailTo::EMAIL_REGEXP},
            uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :password,
            presence: true,
            length: {minimum: Settings.user.password.min_length},
            allow_nil: true

  has_secure_password
end
