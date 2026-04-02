class AddAddressFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :address, :string unless column_exists?(:users, :address)
    add_column :users, :city, :string unless column_exists?(:users, :city)
    add_column :users, :postal_code, :string unless column_exists?(:users, :postal_code)
  end
end
