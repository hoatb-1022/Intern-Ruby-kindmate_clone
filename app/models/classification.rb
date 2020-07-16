class Classification < ApplicationRecord
  belongs_to :campaign
  belongs_to :tag
end
