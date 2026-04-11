ActiveAdmin.register Book do
  permit_params :title, :author, :description, :price,
                :stock_quantity, :category_id, :cover_image,
                :on_sale, :cover_url, tag_ids: []

  index do
    selectable_column
    id_column
    column :cover_image do |book|
      if book.cover_image.attached?
        image_tag book.cover_image.variant(:thumb),
                  style: "height: 50px; width: auto;"
      elsif book.cover_url.present?
        image_tag book.cover_url, style: "height: 50px; width: auto;"
      else
        "No image"
      end
    end
    column :title
    column :author
    column :category
    column :price
    column :stock_quantity
    column :on_sale
    column "Tags" do |book|
      book.tags.map(&:name).join(", ")
    end
    actions
  end

  filter :title
  filter :author
  filter :category
  filter :price
  filter :on_sale, as: :select,
         collection: [["Yes", true], ["No", false]]
  filter :tags_name, as: :string, label: "Tag Name"

  batch_action :mark_as_on_sale do |ids|
    Book.where(id: ids).update_all(on_sale: true)
    redirect_to collection_path, notice: "Books marked as on sale!"
  end

  batch_action :remove_from_sale do |ids|
    Book.where(id: ids).update_all(on_sale: false)
    redirect_to collection_path, notice: "Books removed from sale!"
  end

  form do |f|
    f.inputs "Book Details" do
      f.input :title
      f.input :author
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category
      f.input :on_sale, as: :boolean, label: "On Sale?"
      f.input :cover_url, placeholder: "https://covers.openlibrary.org/..."
      f.input :cover_image, as: :file
      f.input :tags, as: :check_boxes,
              collection: Tag.all,
              label: "Tags (select multiple)"
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
      row :on_sale
      row :category
      row "Tags" do |book|
        book.tags.map(&:name).join(", ")
      end
      row :cover_url
      row :cover_image do |book|
        if book.cover_image.attached?
          image_tag book.cover_image.variant(:large),
                    style: "max-height: 200px;"
        elsif book.cover_url.present?
          image_tag book.cover_url, style: "max-height: 200px;"
        else
          "No image"
        end
      end
      row :created_at
      row :updated_at
    end
  end
end