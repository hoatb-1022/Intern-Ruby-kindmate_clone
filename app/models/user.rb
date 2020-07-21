class User < ApplicationRecord
  PERMIT_ATTRIBUTES =
    %i(
      name
      email
      phone
      address
      description
      password
      password_confirmation
    ).freeze

  enum role: {user: 0, admin: 1}

  attr_accessor :remember_token, :activation_token, :reset_token

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

  before_save :downcase_email
  before_create :create_activation_digest

  scope :ordered_users, ->{order created_at: :desc}

  scope :filter_by_name, (lambda do |name|
    if name.present?
      where arel_table[:name].lower.matches(
        "%#{name.downcase}%"
      )
    end
  end)

  scope :filter_by_email, (lambda do |email|
    if email.present?
      where arel_table[:email].lower.matches(
        "%#{email.downcase}%"
      )
    end
  end)

  scope :filter_by_phone, (lambda do |phone|
    if phone.present?
      where arel_table[:phone].lower.matches(
        "%#{phone.downcase}%"
      )
    end
  end)

  scope :filter_by_address, (lambda do |address|
    if address.present?
      where arel_table[:address].lower.matches(
        "%#{address.downcase}%"
      )
    end
  end)

  scope :filter_by_desc, (lambda do |desc|
    if desc.present?
      where arel_table[:description].lower.matches(
        "%#{desc.downcase}%"
      )
    end
  end)

  scope :filter_by_status, (lambda do |status|
    if status.present?
      where arel_table[:is_blocked].eq(
        status
      )
    end
  end)

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
