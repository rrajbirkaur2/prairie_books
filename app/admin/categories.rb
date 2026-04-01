ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    column "Number of Books" do |category|
      category.books.count
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end
    panel "Books in this Category" do
      table_for category.books do
        column :title
        column :author
        column :price
      end
    end
  end
end