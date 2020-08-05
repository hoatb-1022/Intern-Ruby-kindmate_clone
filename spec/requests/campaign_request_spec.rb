require "rails_helper"

RSpec.describe CampaignsController, type: :controller do
  let!(:current_user) {FactoryBot.create :user, :with_campaigns, campaign_count: 10}
  let!(:current_campaign) {current_user.campaigns.first}
  let!(:params) {FactoryBot.attributes_for :campaign}

  context "when guests don't need login" do
    describe "GET #index" do
      before {get :index, params: {id: current_user.id, page: 1, keyword: ""}}

      it "should render view index" do
        expect(response).to render_template :index
      end

      it "should assign @campaigns" do
        expect(assigns(:campaigns)).to(
          eq(
            Campaign.not_pending
              .filter_by_title_or_desc(params[:keyword])
              .ordered_campaigns
              .page params[:page]
          )
        )
      end
    end

    describe "GET #show" do
      context "when campaign valid" do
        before {get :show, params: {id: current_campaign.id, page: 1}}

        it "should render view show" do
          expect(response).to render_template :show
        end

        it "should assign @donations" do
          expect(assigns(:donations)).to(
            eq(
              current_campaign.donations
                              .ordered_donations
                              .includes(:user)
                              .page 1
            )
          )
        end

        it "should assign @comments" do
          expect(assigns(:donations)).to(
            eq(
              current_campaign.comments
                              .ordered_comments
                              .includes(:user)
                              .page 1
            )
          )
        end

        it "should assign @new_comment" do
          expect(assigns(:new_comment)).to be_a_new(Comment)
        end
      end

      context "when campaign invalid" do
        before {get :show, params: {id: 9999}}

        it "should return error message" do
          expect(flash[:error]).to eq I18n.t("campaigns.not_found")
        end

        it "should redirect to referer or root url" do
          expect(response).to redirect_to request.referer || root_url
        end
      end
    end
  end

  context "when user logged in" do
    before {log_in current_user}

    describe "GET #new" do
      before {get :new}

      it "should render view new" do
        expect(response).to render_template :new
      end

      it "should assign @campaign" do
        expect(assigns(:campaign)).to be_a_new(Campaign)
      end
    end

    describe "POST #create" do
      context "when valid param" do
        before {post :create, params: {campaign: params}}

        it "should redirect to root url" do
          expect(response).to redirect_to root_url
        end

        it "should return success message" do
          expect(flash[:success]).to eq I18n.t("campaigns.success_created")
        end
      end

      context "when invalid param" do
        before {post :create, params: {campaign: {title: ""}}}

        it "should render view new" do
          expect(response).to render_template :new
        end

        it "should return error message" do
          expect(flash[:error]).to eq I18n.t("campaigns.failed_created")
        end
      end
    end

    context "when campaign exists" do
      context "when campaign belongs to current user" do
        describe "GET #edit" do
          before {get :edit, params: {id: current_campaign.id}}

          it "should render view edit" do
            expect(response).to render_template :edit
          end
        end

        describe "PATCH #update" do
          context "when valid param" do
            before {patch :update, params: {id: current_campaign.id, campaign: params}}

            it "should update and redirect to campaign" do
              expect(response).to redirect_to current_campaign
            end

            it "should return success message" do
              expect(flash[:success]).to eq I18n.t("campaigns.success_updated")
            end
          end

          context "when invalid param" do
            before {patch :update, params: {id: current_campaign.id, campaign: {title: ""}}}

            it "should render edit" do
              expect(response).to render_template :edit
            end

            it "should return error message" do
              expect(flash[:error]).to eq I18n.t("campaigns.failed_updated")
            end
          end
        end

        describe "DELETE #destroy" do
          context "when valid param" do
            before {delete :destroy, params: {id: current_campaign.id}}

            it "should return success message" do
              expect(flash[:success]).to eq I18n.t("campaigns.success_deleted")
            end

            it "should redirect to root url" do
              expect(response).to redirect_to root_url
            end
          end

          context "when invalid param" do
            before {delete :destroy, params: {id: 9999}}

            it "should return error message" do
              expect(flash[:error]).to eq I18n.t("campaigns.not_found")
            end
          end
        end
      end

      context "when campaign doesn't belong to current user" do
        let!(:other_user) {FactoryBot.create :user, :with_campaigns, campaign_count: 10}
        let!(:other_campaign) {other_user.campaigns.first}

        it "should return root url" do
          get :edit, params: {id: other_campaign.id}
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when campaign doesn't exist" do
      before {get :edit, params: {id: 9999}, session: {user_id: current_user.id}}

      it "should return error message" do
        expect(flash[:error]).to eq I18n.t("campaigns.not_found")
      end

      it "should redirect request referer or root url" do
        expect(response).to redirect_to request.referer || root_url
      end
    end
  end
end
