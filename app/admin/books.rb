ActiveAdmin.register Book do
  permit_params :title, :author, :description, :price, :stock_quantity, :category_id

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :category
    column :price
    column :stock_quantity
    actions
  end

  filter :title
  filter :author
  filter :category
  filter :price

  form do |f|
    f.inputs "Book Details" do
      f.input :title
      f.input :author
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :author
      row :description
      row :price
      row :stock_quantity
      row :category
      row :created_at
      row :updated_at
    end
  end
end