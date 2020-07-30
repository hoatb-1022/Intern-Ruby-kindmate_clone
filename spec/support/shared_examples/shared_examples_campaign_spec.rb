RSpec.shared_examples "create example campaigns" do
  before do
    FactoryBot.create(
      :campaign,
      title: "Test campaign 1",
      description: "Test Description 1",
      status: "pending",
      user_id: user.id
    )
    FactoryBot.create(
      :campaign,
      title: "Test campaign 2",
      description: "Test Description 2",
      status: "running",
      user_id: user.id
    )
    FactoryBot.create(
      :campaign,
      title: "Test campaign 21",
      description: "Test Description 21",
      status: "stopped",
      user_id: user.id
    )
    FactoryBot.create(
      :campaign,
      title: "Test campaign 22",
      description: "Test Description 3",
      status: "running",
      user_id: user.id
    )
  end
end
