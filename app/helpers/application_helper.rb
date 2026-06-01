module ApplicationHelper
  include Pagy::Frontend

  def page_title
    title = content_for?(:title) ? content_for(:title).to_s.strip : ""

    return "AndyPortfolio" if title.blank?

    "#{title} | AndyPortfolio"
  end
end
