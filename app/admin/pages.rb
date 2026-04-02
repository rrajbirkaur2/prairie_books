ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  actions :all, except: [ :new, :destroy ]

  index do
    id_column
    column :slug
    column :title
    actions
  end

  filter :slug
  filter :title

  form do |f|
    f.inputs "Edit Page Content" do
      f.input :slug, input_html: { disabled: true }
      f.input :title
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :slug
      row :title
      row :content
    end
  end
end
