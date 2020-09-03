RSpec.shared_examples "not found comment" do
  it "should return error message" do
    expect(flash[:error]).to eq I18n.t("comments.not_found")
  end

  it "should redirect to not found url" do
    expect(response).to redirect_to not_found_url
  end
end
