ActiveAdmin.register Book do
  permit_params :title, :publisher_id, :published_date, :description, :isbn, :page_count,
                :language, :image_small_thumbnail, :image_thumbnail, :preview_link, :search_info, :price, :is_on_sale, :sale_price,
                category_ids: [], author_ids: []

  # Set pagination
  config.paginate = true
  config.per_page = 15

  # Index view of Books in ActiveAdmin Dashboard
  index do
    column :id
    column :image_thumbnail do |book|
      image_tag(book.image_thumbnail, height: "50px") if book.image_thumbnail.present?
    end
    column :title
    column :published_date
    column :publisher
    column :description do |book|
      truncate(book.description, length: 100)
    end
    column :isbn
    column :page_count
    column :categories do |book|
      book.categories.map(&:name).join(", ")
    end
    column :authors do |book|
      book.authors.map(&:name).join(", ")
    end
    column :price
    column :is_on_sale
    column :sale_price
    actions
  end

  # View of the one Book details
  show do |book|
    attributes_table do
      row :title
      row :published_date
      row :publisher
      row :description
      row :isbn
      row :page_count
      row :categories do |book|
        book.categories.map(&:name).join(", ")
      end
      row :authors do |book|
        book.authors.map(&:name).join(", ")
      end
      row :image_thumbnail do
        image_tag(book.image_thumbnail, height: "300px") if book.image_thumbnail.present?
      end

      row :categories do
        book.categories.map(&:name).join(", ")
      end

      row :price
      row :is_on_sale
      row :sale_price
    end
    active_admin_comments
  end

  # Form used for Edit and Create pages
  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :page_count
      f.input :image_thumbnail, as: :file
      f.input :categories, as: :select, input_html: { multiple: true },
  collection: Category.order("name asc")
      f.input :authors, as: :select, input_html: { multiple: true },
  collection: Author.order("name asc")
    end

    f.actions
  end
end
