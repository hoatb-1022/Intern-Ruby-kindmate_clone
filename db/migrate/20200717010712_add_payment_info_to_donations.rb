class AddPaymentInfoToDonations < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :payment_type, :integer, default: 0
    add_column :donations, :payment_code, :string
  end
end
