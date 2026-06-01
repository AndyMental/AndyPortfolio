module ApplicationHelper
  def page_title
    title = content_for?(:title) ? content_for(:title).to_s.strip : ""

    return "AndyPortfolio" if title.blank?

    "#{title} | AndyPortfolio"
  end

  def yield_meta_tag(name, default)
    content_for?(name) ? content_for(name) : default
  end

  def breadcrumbs
    crumbs = [link_to("Home", root_path)]

    if controller_name == "blogs"
      if action_name == "show" && @blog&.persisted?
        crumbs << link_to("Blog", blogs_path)
        crumbs << @blog.title
      elsif action_name == "new"
        crumbs << link_to("Blog", blogs_path)
        crumbs << "New Blog"
      elsif action_name == "edit" && @blog&.persisted?
        crumbs << link_to("Blog", blogs_path)
        crumbs << link_to(@blog.title, blog_path(@blog))
        crumbs << "Edit"
      elsif action_name == "index" && request.path != root_path
        crumbs << "Blog"
      end
    end

    return if crumbs.size <= 1

    content_tag(:nav, aria: { label: "Breadcrumb" }) do
      content_tag(:p) do
        safe_join(crumbs, " &nbsp;/&nbsp; ".html_safe)
      end
    end
  end
end
