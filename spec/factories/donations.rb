FactoryBot.define do
  factory :donation do
    amount {Faker::Number.between(from: Settings.donation.min_faker_amount, to: Settings.donation.max_faker_amount)}
    message {Faker::String.random(Settings.donation.max_message_length)}
  end
end
