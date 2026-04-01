ActiveAdmin.register User do
  permit_params :name, :email, :province_id

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :province
    column :created_at
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :province
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :province
      row :created_at
    end
  end
end