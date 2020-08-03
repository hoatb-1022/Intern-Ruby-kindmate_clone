FactoryBot.define do
  factory :campaign do
    title {Faker::String.random(Settings.campaign.title_max_length)}
    description {Faker::String.random(Settings.campaign.title_max_length * 3)}
    content {Faker::String.random(Settings.campaign.title_max_length * 10)}
    total_amount {Faker::Number.between(from: Settings.campaign.min_faker_amount, to: Settings.campaign.max_faker_amount)}
    expired_at {Time.zone.now}
    image {fixture_file_upload "spec/factories/images/test.jpg", "image/jpg"}
  end
end
