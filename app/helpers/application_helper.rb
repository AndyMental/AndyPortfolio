module ApplicationHelper
  SITE_NAME = "AndyPortfolio".freeze
  DEFAULT_DESCRIPTION = "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase.".freeze

  def page_title
    title = content_for?(:title) ? content_for(:title).to_s.strip : ""

    return SITE_NAME if title.blank?

    "#{title} | #{SITE_NAME}"
  end

  def page_description
    description = content_for?(:description) ? content_for(:description).to_s.strip : ""
    description.presence || DEFAULT_DESCRIPTION
  end

  def og_type
    type = content_for?(:og_type) ? content_for(:og_type).to_s.strip : ""
    type.presence || "website"
  end
end
