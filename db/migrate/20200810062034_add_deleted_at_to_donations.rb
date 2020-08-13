class AddDeletedAtToDonations < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :deleted_at, :datetime
    add_index :donations, :deleted_at
  end
end
