ActiveAdmin.register Order do
  permit_params :status, :user_id

  index do
    selectable_column
    id_column
    column :user
    column :status do |order|
      status_tag order.status
    end
    column :subtotal do |order|
      number_with_precision(order.subtotal, precision: 2)
    end
    column :grand_total do |order|
      number_with_precision(order.grand_total, precision: 2)
    end
    column :created_at
    actions
  end

  filter :status
  filter :user
  filter :created_at

  form do |f|
    f.inputs "Order Status" do
      f.input :status, as: :select,
              collection: ["pending", "paid", "shipped"]
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :address
      row :city
      row :province
      row :postal_code
      row :subtotal do |order|
        number_with_precision(order.subtotal, precision: 2)
      end
      row :gst_amount do |order|
        number_with_precision(order.gst_amount, precision: 2)
      end
      row :pst_amount do |order|
        number_with_precision(order.pst_amount, precision: 2)
      end
      row :hst_amount do |order|
        number_with_precision(order.hst_amount, precision: 2)
      end
      row :grand_total do |order|
        number_with_precision(order.grand_total, precision: 2)
      end
      row :created_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :book
        column :quantity
        column :price_at_purchase do |item|
          number_with_precision(item.price_at_purchase, precision: 2)
        end
        column "Subtotal" do |item|
          number_with_precision(item.subtotal, precision: 2)
        end
      end
    end
  end
end