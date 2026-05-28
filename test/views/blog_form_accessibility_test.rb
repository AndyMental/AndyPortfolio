require "test_helper"

class BlogFormAccessibilityTest < ActionView::TestCase
  test "error summary is announced and focusable" do
    blog = Blog.new
    blog.errors.add(:title, "can't be blank")

    render partial: "blogs/form", locals: { blog: blog }

    assert_select "#blog-form-errors[role=?][aria-live=?][tabindex=?]", "alert", "assertive", "-1" do
      assert_select "h2", "1 error prohibited this blog from being saved:"
      assert_select "li", "Title can't be blank"
    end
  end
end
