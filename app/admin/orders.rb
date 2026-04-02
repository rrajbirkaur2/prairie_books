ActiveAdmin.register Order do
  permit_params :status

  actions :all, except: [:new, :destroy]

  index do
    selectable_column
    id_column
    column :user do |order|
      order.user ? "#{order.user.name} (#{order.user.email})" : "Guest"
    end
    column :status do |order|
      case order.status
      when "paid"
        status_tag "paid", class: "green"
      when "shipped"
        status_tag "shipped", class: "blue"
      when "pending"
        status_tag "pending", class: "orange"
      else
        status_tag order.status
      end
    end
    column "Items" do |order|
      order.order_items.map { |item|
        "#{item.book.title} (x#{item.quantity})"
      }.join(", ").truncate(60)
    end
    column "Subtotal" do |order|
      "$#{number_with_precision(order.subtotal, precision: 2)}"
    end
    column "Taxes" do |order|
      total_tax = order.gst_amount.to_f +
                  order.pst_amount.to_f +
                  order.hst_amount.to_f
      "$#{number_with_precision(total_tax, precision: 2)}"
    end
    column "Grand Total" do |order|
      "$#{number_with_precision(order.grand_total, precision: 2)}"
    end
    column :created_at
    actions
  end

  filter :status, as: :select,
         collection: ["pending", "paid", "shipped"]
  filter :user
  filter :created_at

  # Batch actions for changing status
  batch_action :mark_as_paid do |ids|
    Order.where(id: ids).update_all(status: "paid")
    redirect_to collection_path, notice: "Orders marked as paid!"
  end

  batch_action :mark_as_shipped do |ids|
    Order.where(id: ids).update_all(status: "shipped")
    redirect_to collection_path, notice: "Orders marked as shipped!"
  end

  form do |f|
    f.inputs "Update Order Status" do
      f.input :status, as: :select,
              collection: [
                ["Pending", "pending"],
                ["Paid", "paid"],
                ["Shipped", "shipped"]
              ],
              include_blank: false
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user do |order|
        order.user ? "#{order.user.name} (#{order.user.email})" : "Guest"
      end
      row :status do |order|
        case order.status
        when "paid"
          status_tag "paid", class: "green"
        when "shipped"
          status_tag "shipped", class: "blue"
        when "pending"
          status_tag "pending", class: "orange"
        else
          status_tag order.status
        end
      end
      row "Shipping Address" do |order|
        "#{order.address}, #{order.city}, " \
        "#{order.province&.name} #{order.postal_code}"
      end
      row "Subtotal" do |order|
        "$#{number_with_precision(order.subtotal, precision: 2)}"
      end
      row "GST" do |order|
        "$#{number_with_precision(order.gst_amount, precision: 2)} " \
        "(#{number_with_precision(order.gst_rate.to_f * 100, precision: 1)}%)"
      end
      row "PST" do |order|
        "$#{number_with_precision(order.pst_amount, precision: 2)} " \
        "(#{number_with_precision(order.pst_rate.to_f * 100, precision: 1)}%)"
      end
      row "HST" do |order|
        "$#{number_with_precision(order.hst_amount, precision: 2)} " \
        "(#{number_with_precision(order.hst_rate.to_f * 100, precision: 1)}%)"
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

    # Manual ship button
    panel "Actions" do
      if order.status == "paid"
        link_to "Mark as Shipped",
                mark_shipped_admin_order_path(order),
                method: :put,
                class: "btn btn-info",
                data: { confirm: "Mark this order as shipped?" }
      elsif order.status == "pending"
        para "Waiting for payment confirmation."
      else
        para "Order has been shipped."
      end
    end
  end

  # Custom action to mark as shipped
  member_action :mark_shipped, method: :put do
    resource.update!(status: "shipped")
    redirect_to admin_order_path(resource),
                notice: "Order marked as shipped!"
  end
end