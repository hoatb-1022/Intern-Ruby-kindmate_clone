RSpec.shared_examples "create example notifications" do
  before do
    FactoryBot.create(
      :notification,
      title: "Test campaign 1",
      body: "Test body 1",
      user_id: user.id
    )
    FactoryBot.create(
      :notification,
      title: "Test campaign 2",
      body: "Test body 2",
      user_id: user.id,
      is_viewed: true
    )
    FactoryBot.create(
      :notification,
      title: "Test campaign 3",
      body: "Test body 3",
      user_id: user.id,
      is_viewed: true
    )
    FactoryBot.create(
      :notification,
      title: "Test campaign 4",
      body: "Test body 4",
      user_id: user.id
    )
    FactoryBot.create(
      :notification,
      title: "Test campaign 5",
      body: "Test body 5",
      user_id: user.id
    )
  end
end
