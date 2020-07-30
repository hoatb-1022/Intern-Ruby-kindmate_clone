FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.unique.email}
    phone {"038#{Faker::Number.unique.number(digits: 7)}"}
    password {Settings.user.default_password}
    password_confirmation {Settings.user.default_password}
  end
end
