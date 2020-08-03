require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:current_user) {FactoryBot.create :user, :with_campaigns, campaign_count: 10}
  let!(:params) {FactoryBot.attributes_for :user}

  context "when guests don't need login" do
    describe "GET #show" do
      context "when user valid" do
        before {get :show, params: {id: current_user.id}}

        it "should render view show" do
          expect(response).to render_template :show
        end

        it "should assign @campaigns" do
          expect(assigns(:campaigns)).to eq(current_user.campaigns.ordered_campaigns_by_donated.page 1)
        end
      end

      context "when user invalid" do
        before {get :show, params: {id: 9999}}

        it "should return error message" do
          expect(flash[:error]).to eq I18n.t("users.not_found")
        end

        it "should redirect to referer or root url" do
          expect(response).to redirect_to request.referer || root_url
        end
      end
    end

    describe "GET #new" do
      before {get :new}

      it "should render view new" do
        expect(response).to render_template :new
      end

      it "should assign @user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST #create" do
      context "when valid param" do
        let!(:count_all_users) {User.count}

        before {post :create, params: {user: params}}

        it "should increase User.count" do
          expect(User.count).to eq count_all_users + 1
        end

        it "should redirect login url" do
          expect(response).to redirect_to login_url
        end

        it "should return success message" do
          expect(flash[:success]).to eq I18n.t("users.new.success_create_account")
        end
      end

      context "when invalid param" do
        before {post :create, params: {user: {name: ""}}}

        it "should render view new" do
          expect(response).to render_template :new
        end

        it "should return error message" do
          expect(flash[:error]).to eq I18n.t("users.new.failed_create_account")
        end
      end
    end
  end

  context "when user logged in" do
    context "when user exists" do
      before {log_in current_user}

      describe "GET #edit" do
        before {get :edit, params: {id: current_user.id}}

        context "when user is current logged in account" do
          it "should render view edit" do
            expect(response).to render_template :edit
          end
        end

        context "when user is not current logged in account" do
          let(:wrong_user) {FactoryBot.create :user}
          before do
            log_in wrong_user
            get :edit, params: {id: current_user.id}
          end

          it "should redirect to root url" do
            expect(response).to redirect_to root_url
          end
        end
      end

      describe "PATCH #update" do
        context "when valid param" do
          before {patch :update, params: {id: current_user.id, user: params}}

          it "should update and redirect to user" do
            expect(response).to redirect_to current_user
          end

          it "should return success message" do
            expect(flash[:success]).to eq I18n.t("users.edit.profile_updated")
          end
        end

        context "when invalid param" do
          before {patch :update, params: {id: current_user.id, user: {name: ""}}}

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
          before {delete :destroy, params: {id: current_user.id}}

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
        expect(response).to redirect_to request.referer || root_url
      end
    end
  end
end
