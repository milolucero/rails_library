ActiveAdmin.register Book do
  permit_params :title, :publisher_id, :published_date, :description, :isbn, :page_count, :image,
                :language, :image_small_thumbnail, :image_thumbnail, :preview_link, :search_info, :price, :is_on_sale, :sale_price,
                book_categories_attributes: %i[id book_categories_id category_id _destroy],
                book_authors_attributes:    %i[id book_authors_id author_id _destroy]
  # Set pagination
  config.paginate = true
  config.per_page = 15

  # Index view of Books in ActiveAdmin Dashboard
  index do
    selectable_column
    column :id
    column :image do |book|
      if book.image.present?
        image_tag(book.image.variant(resize_to_limit: [100, 100]))
      elsif book.image_thumbnail.present?
        image_tag(book.image_thumbnail, height: "100px")
      else
        content_tag(:span, "No Image")
      end
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
      book.categories.map(&:name).join(", ").html_safe
    end
    column :authors do |book|
      book.authors.map(&:name).join(", ").html_safe
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
        book.categories.map(&:name).join(", ").html_safe
      end
      row :authors do |book|
        book.authors.map(&:name).join(", ").html_safe
      end
      row :image do
        if book.image.present?
          image_tag(book.image.variant(resize_to_limit: [200, 300]))
        elsif book.image_thumbnail.present?
          image_tag(book.image_thumbnail, height: "300px")
        else
          content_tag(:span, "No Image")
        end
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
      if f.object.image.present?
        f.input :image, as: :file, hint: image_tag(f.object.image.variant(resize_to_limit: [200, 250]))
      elsif f.object.image_thumbnail.present?
        f.input :image, as: :file, hint: image_tag(f.object.image_thumbnail, size: "200x250")
      else
        f.input :image, as: :file
      end
      f.has_many :book_categories, allow_destroy: true do |n_f|
        n_f.input :category
      end
      f.has_many :book_authors, allow_destroy: true do |n_f|
        n_f.input :author
      end
    end
    f.actions
  end
end
