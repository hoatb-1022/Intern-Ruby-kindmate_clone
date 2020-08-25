class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :phone, :email, :address, :description

  has_many :campaigns, lazy_load_data: true, links: {
    related: ->(object){"#{ENV['default_full_url']}/api/v1/users/#{object.id}/campaigns"}
  }
  has_many :donations
  has_many :comments
  has_many :notifications
end
