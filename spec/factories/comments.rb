FactoryBot.define do
  factory :comment do
    content {Faker::String.random(Settings.comment.max_content_length)}
  end
end
