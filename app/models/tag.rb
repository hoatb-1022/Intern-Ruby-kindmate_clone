class Tag < ApplicationRecord
  has_many :classifications, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.tag.max_length}
end
