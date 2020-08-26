class User < ApplicationRecord
  PERMIT_ATTRIBUTES =
    %i(
      name
      email
      phone
      address
      description
      avatar
      password
      password_confirmation
      latitude
      longitude
    ).freeze

  extend FriendlyId
  friendly_id :name, use: :slugged

  rolify

  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable,
         :omniauthable, omniauth_providers: %i(facebook google_oauth2 github)

  enum role: {user: 0, admin: 1}

  has_many :campaigns, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true
  validates :phone,
            presence: true,
            format: {with: Settings.user.phone_regex},
            uniqueness: true,
            if: :phone_required?
  validate :coordinates_must_exists

  before_save :downcase_email
  after_create :assign_default_role

  scope :ordered_users, ->{order created_at: :desc}

  scope :ordered_and_paginated, ->(page){ordered_users.page page}

  class << self
    def new_with_session params, session
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def from_omniauth auth
      auth_user = User.find_by email: auth.info.email
      return auth_user if auth_user

      omniauth_user auth
    end

    def omniauth_user auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
        user.image_url = auth.info.image
        user.confirmed_at = Time.zone.now
      end
    end

    def generate_jwt_token user
      JWT.encode(
        {
          user_id: user.id,
          typ: "access",
          exp: (Time.zone.now + 2.weeks).to_i
        },
        Rails.application.secrets.secret_key_base,
        "HS256"
      )
    end
  end

  private

  def downcase_email
    email.downcase! if email.present?
  end

  def password_required?
    new_record? ? super : false
  end

  def email_required?
    email.present? || provider.blank? ? super : false
  end

  def phone_required?
    provider.blank?
  end

  def assign_default_role
    add_role :user
  end

  def coordinates_must_exists
    return if address.blank? || ((-180..180).include?(longitude) && (-90..90).include?(latitude))

    errors.add :address, I18n.t("users.edit.must_exist_on_map")
  end
end
