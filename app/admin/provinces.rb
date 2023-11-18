ActiveAdmin.register Province do
  permit_params :name, :name_abbreviation, :gst, :pst, :hst

  index do
    column :id
    column :name
    column :name_abbreviation
    column :gst
    column :pst
    column :hst
    actions
  end
end
