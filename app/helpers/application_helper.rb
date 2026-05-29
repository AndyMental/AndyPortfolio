module ApplicationHelper
  DEFAULT_META_DESCRIPTION =
    "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase.".freeze

  def default_meta_description
    DEFAULT_META_DESCRIPTION
  end

  def page_title
    content_for?(:page_title) ? content_for(:page_title) : "AndyPortfolio"
  end
end
