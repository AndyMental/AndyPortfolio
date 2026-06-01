module ApplicationHelper
  def page_title
    title = content_for?(:title) ? content_for(:title).to_s.strip : ""

    return "AndyPortfolio" if title.blank?

    "#{title} | AndyPortfolio"
  end

  def yield_meta_tag(name, default)
    content_for?(name) ? content_for(name) : default
  end

  def nav_link_to(name, path, active: :exact, **html_options)
    if nav_link_active?(path, active)
      html_options[:class] = [html_options[:class], "current"].compact.join(" ")
      html_options[:"aria-current"] = "page"
    end

    link_to name, path, html_options
  end

  private

  def nav_link_active?(path, active)
    target_path = path.to_s

    case active
    when :inclusive
      request.path == target_path || request.path.start_with?("#{target_path}/")
    else
      request.path == target_path
    end
  end
end
