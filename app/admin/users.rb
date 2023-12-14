ActiveAdmin.register User do
  permit_params :username, :email, :first_name, :last_name, :password, :city, :postal_code, :province_id, :address

  # Set pagination
  config.paginate = true
  config.per_page = 25

  index do
    column :id
    column :username
    column :email
    column :first_name
    column :last_name
    column :password
    column :city
    column :postal_code
    column :province do |user|
      user.province&.name
    end
    column :address
    actions
  end

  show do |user|
    attributes_table do
      row :id
      row :username
      row :email
      row :first_name
      row :last_name
      row :password
      row :city
      row :postal_code
      row :province do |user|
        user.province&.name
      end
      row :address
      row :created_at
      row :updated_at
      active_admin_comments
    end
  end

  # Form used for Edit and Create pages
  form do |f|
    f.semantic_errors
    f.inputs
    f.actions
  end
end
