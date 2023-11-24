class PagesController < ApplicationController
    def show
      @page = Page.friendly.find(params[:slug])

      @is_contact_page = (@page.slug == 'contact')
  end
end
