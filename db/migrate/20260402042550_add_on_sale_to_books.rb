class AddOnSaleToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :on_sale, :boolean, default: false
  end
end