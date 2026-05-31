module BlogsHelper
  BLOG_BODY_TAGS = %w[p br strong em b i ul ol li a].freeze
  BLOG_BODY_ATTRIBUTES = %w[href title rel target].freeze

  REL_SAFETY_TOKENS = %w[noopener noreferrer].freeze

  def rendered_blog_body(body)
    sanitized = sanitize(body, tags: BLOG_BODY_TAGS, attributes: BLOG_BODY_ATTRIBUTES)
    fragment = Nokogiri::HTML::DocumentFragment.parse(sanitized.to_s)

    fragment.css("a[target]").each do |anchor|
      tokens = anchor["rel"].to_s.split(/\s+/).reject(&:empty?)
      tokens |= REL_SAFETY_TOKENS
      anchor["rel"] = tokens.join(" ")
    end

    fragment.to_html.html_safe
  end
end
