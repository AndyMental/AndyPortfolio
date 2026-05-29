class SitemapController < ApplicationController
  def index
    @blogs = Blog.all
    respond_to do |format|
      format.xml
    end
  end
end
