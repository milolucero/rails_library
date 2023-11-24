ActiveAdmin.register Page do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :title, :content, :phone, :email, :address, :slug

   # Edit page
   form do |f|
    f.inputs do
      f.input :title
      f.input :content
      if f.object.slug == 'contact'
        f.input :phone
        f.input :email
        f.input :address
      end
    end
    f.actions
  end

  # View page
  show do
    attributes_table do
      row :title
      row :content

      # Check if it's an About page based on the slug
      unless resource.slug == 'about'
        row :phone
        row :email
        row :address
      end

    end
    active_admin_comments
  end

  # Allowed actions in Active Admin for Page model
  actions :index, :show, :edit, :update

  # Uses friendly.find to find a Page by its slug.
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :content, :phone, :email, :address, :slug]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
