FactoryBot.define do
  factory :campaign do
    title {Faker::String.random(Settings.campaign.title_max_length)}
    description {Faker::String.random(Settings.campaign.title_max_length * 3)}
    content {Faker::String.random(Settings.campaign.title_max_length * 10)}
    total_amount {Faker::Number.between(from: Settings.campaign.min_faker_amount, to: Settings.campaign.max_faker_amount)}
    expired_at {Time.zone.now}
    image {fixture_file_upload "spec/factories/images/test.jpg", "image/jpg"}

    trait :with_comments do
      transient do
        comment_count {5}
      end

      after(:create) do |campaign, evaluator|
        (0..evaluator.comment_count).each do
          create(:comment, commentable_type: "Campaign", commentable_id: campaign.id, user_id: campaign.user.id)
        end
      end
    end
  end
end
