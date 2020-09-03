require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:current_user) {FactoryBot.create :user, :with_campaigns, campaign_count: 10}
  let!(:current_campaign) {FactoryBot.create :campaign, :with_comments, comment_count: 10, user_id: current_user.id}
  let!(:current_comment) {current_campaign.comments.first}
  let!(:comment_params) {FactoryBot.attributes_for :comment, commentable_type: "Campaign", commentable_id: current_campaign.id}

  context "when user doesn't log in" do
    describe "POST #create" do
      before {post :create, params: {campaign_id: current_campaign.id}}
      it_behaves_like "not logged in user"
    end

    describe "POST #update" do
      before {post :update, params: {campaign_id: current_campaign.id, id: current_comment.id}}
      it_behaves_like "not logged in user"
    end

    describe "POST #destroy" do
      before {post :destroy, params: {campaign_id: current_campaign.id, id: current_comment.id}}
      it_behaves_like "not logged in user"
    end
  end

  context "when used logged in" do
    before {log_in current_user}

    context "when campaign not found" do
      describe "POST #create" do
        before {post :create, params: {campaign_id: current_campaign.id}}
        it_behaves_like "not found campaign"
      end

      describe "POST #update" do
        before {post :update, params: {campaign_id: current_campaign.id, id: current_comment.id}}
        it_behaves_like "not found campaign"
      end

      describe "POST #destroy" do
        before {post :destroy, params: {campaign_id: current_campaign.id, id: current_comment.id}}
        it_behaves_like "not found campaign"
      end
    end

    context "when campaign found" do
      describe "POST #create" do
        before {post :create, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug}}

        it "should assign @campaign" do
          expect(assigns(:campaign)).to_not eq(nil)
        end
      end

      describe "POST #update" do
        before {post :update, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug, id: current_comment.id}}

        it "should assign @campaign" do
          expect(assigns(:campaign)).to_not eq(nil)
        end
      end

      describe "POST #destroy" do
        before {post :destroy, format: :js, params: {campaign_id: current_campaign.slug, id: current_comment.id}}

        it "should assign @campaign" do
          expect(assigns(:campaign)).to_not eq(nil)
        end
      end

      context "when commentable found" do
        describe "POST #create" do
          let!(:old_count) {Comment.count}
          before {post :create, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug}}

          it "should assign @commentable" do
            expect(assigns(:commentable)).to_not eq(nil)
          end

          it "should render js" do
            expect(response.content_type).to include("text/javascript")
          end

          context "when successfully created" do
            it_behaves_like "refind comments"

            it "should increments the count" do
              expect(Comment.count).to eq old_count + 1
            end
          end
        end

        describe "POST #update" do
          before {post :update, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug, id: current_comment.id}}

          it "should assign @commentable" do
            expect(assigns(:commentable)).to_not eq(nil)
          end
        end

        describe "POST #destroy" do
          before {post :destroy, format: :js, params: {campaign_id: current_campaign.slug, id: current_comment.id}}

          it "should assign @commentable" do
            expect(assigns(:commentable)).to_not eq(nil)
          end
        end

        context "when comment not found" do
          describe "POST #update" do
            before {post :update, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug, id: 999}}
            it_behaves_like "not found comment"
          end

          describe "POST #destroy" do
            before {post :destroy, format: :js, params: {campaign_id: current_campaign.slug, id: 999}}
            it_behaves_like "not found comment"
          end
        end

        context "when comment found" do
          describe "POST #update" do
            before {post :update, format: :js, params: {comment: comment_params, campaign_id: current_campaign.slug, id: current_comment.id}}

            it "should assign @comment" do
              expect(assigns(:comment)).to_not eq(nil)
            end

            it "should render js" do
              expect(response.content_type).to include("text/javascript")
            end

            context "when successfully updated" do
              it_behaves_like "refind comments"
            end
          end

          describe "POST #destroy" do
            before {post :destroy, format: :js, params: {campaign_id: current_campaign.slug, id: current_comment.id, page: 1}}

            it "should assign @comment" do
              expect(response.content_type).to include("text/javascript")
            end

            it "should render js" do
              expect(response.content_type).to include("text/javascript")
            end

            context "when successfully destroyed" do
              it_behaves_like "refind comments"
            end
          end
        end
      end
    end
  end
end
