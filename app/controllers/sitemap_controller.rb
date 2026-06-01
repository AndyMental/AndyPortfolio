class SitemapController < ApplicationController
  def index
    @blogs = Blog.all.order(created_at: :desc, id: :desc)
    respond_to do |format|
      format.xml
    end
  end
end
