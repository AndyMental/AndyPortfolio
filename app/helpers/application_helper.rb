module ApplicationHelper
  def page_title
    title = content_for?(:title) ? content_for(:title).to_s.strip : ""

    return "AndyPortfolio" if title.blank?

    "#{title} | AndyPortfolio"
  end

  def page_description
    content_for?(:description) ? content_for(:description) : "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase."
  end

  def og_title
    content_for?(:title) ? content_for(:title) : "AndyPortfolio"
  end

  def og_type
    content_for?(:og_type) ? content_for(:og_type) : "website"
  end
end
