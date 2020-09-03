FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.unique.email}
    phone {"038#{Faker::Number.unique.number(digits: 7)}"}
    password {Settings.user.default_password}
    password_confirmation {Settings.user.default_password}
    confirmed_at {Time.zone.now}

    trait :with_campaigns do
      transient do
        campaign_count {5}
      end

      after(:create) do |user, evaluator|
        (0..evaluator.campaign_count).each do
          create(:campaign, user_id: user.id)
        end
      end
    end
  end
end
