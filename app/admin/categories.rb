ActiveAdmin.register Category do
  permit_params :name

  # Set pagination
  config.paginate = true
  config.per_page = 15

  index do
    column :id
    column :name
    actions
  end
end
