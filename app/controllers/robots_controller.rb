class RobotsController < ApplicationController
  def show
    body = <<~TXT
      User-agent: *
      Allow: /
      Sitemap: #{sitemap_url}
    TXT
    render plain: body
  end
end
