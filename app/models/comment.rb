class Comment < ApplicationRecord
  belongs_to :user, :campaign

  validates :content, presence: true
end
