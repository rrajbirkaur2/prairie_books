class AddFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :user_id, :integer
    add_column :orders, :province_id, :integer
    add_column :orders, :gst_rate, :decimal
    add_column :orders, :pst_rate, :decimal
    add_column :orders, :hst_rate, :decimal
    add_column :orders, :gst_amount, :decimal
    add_column :orders, :pst_amount, :decimal
    add_column :orders, :hst_amount, :decimal
    add_column :orders, :subtotal, :decimal
    add_column :orders, :grand_total, :decimal
    add_column :orders, :stripe_payment_id, :string
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :postal_code, :string
  end
end
