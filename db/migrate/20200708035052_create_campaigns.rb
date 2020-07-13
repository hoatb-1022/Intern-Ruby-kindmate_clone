class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :content
      t.text :description
      t.text :embedded_link
      t.integer :total_amount, default: 0
      t.datetime :expired_at
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
