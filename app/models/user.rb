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

  rolify

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

  before_save :downcase_email
  after_create :assign_default_role

  scope :ordered_users, ->{order created_at: :desc}

  scope :ordered_and_paginated, ->(page){ordered_users.page page}

  protected

  def downcase_email
    email.downcase!
  end

  def password_required?
    new_record? ? super : false
  end

  def assign_default_role
    add_role :user if new_record?
  end
end
