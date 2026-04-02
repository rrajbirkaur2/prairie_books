class AddStripeFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :stripe_payment_id, :string unless column_exists?(:orders, :stripe_payment_id)
    add_column :orders, :stripe_customer_id, :string unless column_exists?(:orders, :stripe_customer_id)
  end
end