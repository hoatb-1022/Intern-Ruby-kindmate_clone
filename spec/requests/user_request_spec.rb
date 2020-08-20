require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:user) {FactoryBot.create :user, :with_campaigns, campaign_count: 10}
  let!(:params) {FactoryBot.attributes_for :user}

  context "when guests don't need login" do
    describe "GET #show" do
      context "when user valid" do
        before {get :show, params: {id: user.id}}

        it "should render view show" do
          expect(response).to render_template :show
        end

        it "should assign @campaigns" do
          expect(assigns(:campaigns)).to_not eq(nil)
        end
      end

      context "when user invalid" do
        before {get :show, params: {id: 9999}}

        it "should return error message" do
          expect(flash[:error]).to eq I18n.t("users.not_found")
        end

        it "should redirect to referer or root url" do
          expect(response).to redirect_to request.referer || not_found_url
        end
      end
    end
  end

  context "when user logged in" do
    context "when user exists" do
      before {log_in user}

      describe "GET #edit" do
        before {get :edit, params: {id: user.id}}

        context "when user is current logged in account" do
          it "should render view edit" do
            expect(response).to render_template :edit
          end
        end

        context "when user is not current logged in account" do
          before do
            sign_out user
            log_in nil
            get :edit, params: {id: user.id}
          end

          it "should redirect to root url" do
            expect(response).to redirect_to root_url
          end
        end
      end

      describe "PATCH #update" do
        context "when valid param" do
          before {patch :update, params: {id: user.id, user: params}}

          it "should update and redirect to user" do
            expect(response).to redirect_to user
          end

          it "should return success message" do
            expect(flash[:success]).to eq I18n.t("users.edit.profile_updated")
          end
        end

        context "when invalid param" do
          before {patch :update, params: {id: user.id, user: {name: ""}}}

          it "should render edit" do
            expect(response).to render_template :edit
          end

          it "should return error message" do
            expect(flash[:error]).to eq I18n.t("users.edit.failed_update_profile")
          end
        end
      end

      describe "DELETE #destroy" do
        context "when valid param" do
          before {delete :destroy, params: {id: user.id}}

          it "should return success message" do
            expect(flash[:success]).to eq I18n.t("users.edit.user_deleted")
          end

          it "redirect to admin user page" do
            expect(response).to redirect_to admin_users_path
          end
        end
      end
    end

    context "when user doesn't exist" do
      before {get :show, params: {id: 9999}}

      it "should return error message" do
        expect(flash[:error]).to eq I18n.t("users.not_found")
      end

      it "should redirect request referer or root url" do
        expect(response).to redirect_to request.referer || not_found_url
      end
    end
  end
end
