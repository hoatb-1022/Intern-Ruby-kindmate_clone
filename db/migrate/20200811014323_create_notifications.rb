class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.string :target
      t.boolean :is_viewed, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
