RSpec.shared_examples "not found campaign" do
  it "should return error message" do
    expect(flash[:error]).to eq I18n.t("campaigns.not_found")
  end

  it "should redirect to request referer or not found url" do
    expect(response).to redirect_to request.referer || not_found_url
  end
end
