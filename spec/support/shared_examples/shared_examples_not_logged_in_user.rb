RSpec.shared_examples "not logged in user" do
  it "should return error message" do
    expect(flash[:error]).to eq I18n.t("global.please_login")
  end

  it "should redirect to login url" do
    expect(response).to redirect_to login_url
  end
end
