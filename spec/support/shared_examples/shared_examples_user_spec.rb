RSpec.shared_examples "create example users" do
  before do
    FactoryBot.create(
      :user,
      name: "Test User 0",
      email: "user1@test.com",
      phone: "0385656556",
      address: "Test Address 1",
      description: "Test Description 1",
      is_blocked: false
    )
    FactoryBot.create(
      :user,
      name: "Test User 1",
      email: "user2@test.com",
      phone: "0385656557",
      address: "Test Address 1, 2",
      description: "Test Description 11",
      is_blocked: true
    )
    FactoryBot.create(
      :user,
      name: "Test User 2",
      email: "user3@test.com",
      phone: "0385656558",
      address: "Test Address 3",
      description: "Test Description 3",
      is_blocked: false
    )
    FactoryBot.create(
      :user,
      name: "Test Admin 1",
      email: "admin1@test.com",
      phone: "0385656559",
      address: "Test Address 4",
      description: "Test Description 4",
      is_blocked: false
    )
  end
end
