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

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  enum role: {user: 0, admin: 1}

  has_many :campaigns, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true

  scope :ordered_users, ->{order created_at: :desc}

  scope :filter_by_name, ->(value){filter_by_string_attr :name, value}

  scope :filter_by_email, ->(value){filter_by_string_attr :email, value}

  scope :filter_by_phone, ->(value){filter_by_string_attr :phone, value}

  scope :filter_by_address, ->(value){filter_by_string_attr :address, value}

  scope :filter_by_desc, ->(value){filter_by_string_attr :description, value}

  scope :filter_by_status, ->(value){filter_by_number_attr :is_blocked, value}

  protected

  def password_required?
    new_record? ? super : false
  end
end
