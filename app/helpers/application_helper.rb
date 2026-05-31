module ApplicationHelper
  def page_title
    if content_for?(:title)
      "#{content_for(:title)} | AndyPortfolio"
    else
      "AndyPortfolio"
    end
  end
end
