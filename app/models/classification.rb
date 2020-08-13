class Classification < ApplicationRecord
  acts_as_paranoid

  belongs_to :campaign
  belongs_to :tag
end
