ActiveAdmin.register Tag do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column "Books" do |tag|
      tag.books.count
    end
    actions
  end

  form do |f|
    f.inputs "Tag Details" do
      f.input :name
    end
    f.actions
  end
end