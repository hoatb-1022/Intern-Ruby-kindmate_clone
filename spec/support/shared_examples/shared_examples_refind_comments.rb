RSpec.shared_examples "refind comments" do
  it "should assign @comments" do
    expect(assigns(:comments)).to(
      eq(
        current_campaign.comments
          .ordered_comments
          .includes(:user)
          .page 1
      )
    )
  end
end
