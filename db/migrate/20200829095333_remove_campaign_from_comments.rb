class RemoveCampaignFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comments, :campaign, null: false, foreign_key: true
  end
end
