class CampaignSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content, :description, :embedded_link, :total_amount, :expired_at, :status, :donated_amount

  belongs_to :user, lazy_load_data: true, links: {
    related: ->(object){"#{ENV['default_full_url']}/api/v1/users/#{object.id}"}
  }
  has_many :donations
  has_many :comments
  has_many :classifications
  has_many :tags, through: :classifications
end
