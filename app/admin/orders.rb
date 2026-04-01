ActiveAdmin.register Order do
  permit_params :status, :total_price, :user_id

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total_price
    column :created_at
    actions
  end

  filter :status
  filter :user
  filter :created_at

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :status, as: :select, collection: ["pending", "paid", "shipped"]
      f.input :total_price
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :status
      row :total_price
      row :created_at
    end
    panel "Order Items" do
      table_for order.order_items do
        column :book
        column :quantity
        column :price_at_purchase
      end
    end
  end
end