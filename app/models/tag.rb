class Tag < ApplicationRecord
  has_many :classifications, dependent: :destroy
  has_many :campaigns, through: :classifications

  validates :name, presence: true, length: {maximum: Settings.tag.max_length}
end
