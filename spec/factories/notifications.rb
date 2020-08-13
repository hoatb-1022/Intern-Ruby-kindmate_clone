FactoryBot.define do
  factory :notification do
    title {Faker::String.random(Settings.notification.max_title_length)}
    body {Faker::String.random(Settings.notification.max_body_length)}
    target {"/"}
  end
end
