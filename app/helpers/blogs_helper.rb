require "nokogiri"

module BlogsHelper
  BLOG_BODY_TAGS = %w[p br strong em b i ul ol li a img].freeze
  BLOG_BODY_ATTRIBUTES = %w[href title rel target src alt].freeze

  def rendered_blog_body(blog)
    fragment = Nokogiri::HTML::DocumentFragment.parse(blog.body.to_s)
    fallback_alt = blog_image_alt_text(blog)

    fragment.css("img").each do |image|
      image["alt"] = fallback_alt if image["alt"].blank?
    end

    sanitize(fragment.to_html, tags: BLOG_BODY_TAGS, attributes: BLOG_BODY_ATTRIBUTES)
  end

  private

  def blog_image_alt_text(blog)
    title = blog.title.to_s.strip

    title.present? ? "Image from #{title}" : "Blog image"
  end
end
