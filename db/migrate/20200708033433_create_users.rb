class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :address
      t.text :description
      t.boolean :is_blocked, default: false

      t.timestamps
    end
  end
end
