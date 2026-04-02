ActiveAdmin.register Order do
  permit_params :status, :user_id

  actions :all, except: [:new, :destroy]

  index do
    selectable_column
    id_column
    column :user do |order|
      if order.user
        link_to order.user.name, admin_user_path(order.user)
      else
        "Guest"
      end
    end
    column "Customer Email" do |order|
      order.user&.email
    end
    column :status do |order|
      status_tag order.status
    end
    column "Items" do |order|
      order.order_items.map { |item|
        "#{item.book.title} (x#{item.quantity})"
      }.join(", ").truncate(50)
    end
    column "Subtotal" do |order|
      "$#{number_with_precision(order.subtotal, precision: 2)}"
    end
    column "Taxes" do |order|
      total_tax = order.gst_amount.to_f + order.pst_amount.to_f + order.hst_amount.to_f
      "$#{number_with_precision(total_tax, precision: 2)}"
    end
    column "Grand Total" do |order|
      "$#{number_with_precision(order.grand_total, precision: 2)}"
    end
    column :created_at
    actions
  end

  filter :status
  filter :user
  filter :created_at

  form do |f|
    f.inputs "Update Order Status" do
      f.input :status, as: :select,
              collection: ["pending", "paid", "shipped"]
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user do |order|
        if order.user
          link_to order.user.name, admin_user_path(order.user)
        end
      end
      row "Customer Email" do |order|
        order.user&.email
      end
      row :status do |order|
        status_tag order.status
      end
      row "Shipping Address" do |order|
        "#{order.address}, #{order.city}, #{order.province&.name} #{order.postal_code}"
      end
      row "Subtotal" do |order|
        "$#{number_with_precision(order.subtotal, precision: 2)}"
      end
      row "GST" do |order|
        "$#{number_with_precision(order.gst_amount, precision: 2)} (#{number_with_precision(order.gst_rate.to_f * 100, precision: 1)}%)"
      end
      row "PST" do |order|
        "$#{number_with_precision(order.pst_amount, precision: 2)} (#{number_with_precision(order.pst_rate.to_f * 100, precision: 1)}%)"
      end
      row "HST" do |order|
        "$#{number_with_precision(order.hst_amount, precision: 2)} (#{number_with_precision(order.hst_rate.to_f * 100, precision: 1)}%)"
      end
      row "Grand Total" do |order|
        "$#{number_with_precision(order.grand_total, precision: 2)}"
      end
      row :stripe_payment_id
      row :created_at
    end

    panel "Order Items" do
      table_for order.order_items.includes(:book) do
        column "Book" do |item|
          link_to item.book.title, admin_book_path(item.book)
        end
        column "Author" do |item|
          item.book.author
        end
        column :quantity
        column "Price at Purchase" do |item|
          "$#{number_with_precision(item.price_at_purchase, precision: 2)}"
        end
        column "Subtotal" do |item|
          "$#{number_with_precision(item.subtotal, precision: 2)}"
        end
      end
    end
  end
end