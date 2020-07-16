class AddDonatedAmountToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :donated_amount, :integer, default: 0
  end
end
