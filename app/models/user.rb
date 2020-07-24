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
    ).freeze

  enum role: {user: 0, admin: 1}

  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :campaigns, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar

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
  validates :avatar,
            content_type: {
              in: Settings.global.format_image_accept,
              message: I18n.t("global.valid_image_format!")
            },
            size: {
              less_than: Settings.user.max_image_size,
              message: I18n.t(
                "global.valid_image_size!",
                maximum: Settings.user.max_image_num
              )
            }

  before_save :downcase_email
  before_create :create_activation_digest

  scope :ordered_users, ->{order created_at: :desc}

  scope :filter_by_name, ->(value){filter_by_string_attr :name, value}

  scope :filter_by_email, ->(value){filter_by_string_attr :email, value}

  scope :filter_by_phone, ->(value){filter_by_string_attr :phone, value}

  scope :filter_by_address, ->(value){filter_by_string_attr :address, value}

  scope :filter_by_desc, ->(value){filter_by_string_attr :description, value}

  scope :filter_by_status, ->(value){filter_by_number_attr :is_blocked, value}

  has_secure_password

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token),
           reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
