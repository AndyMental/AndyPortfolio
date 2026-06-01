require "test_helper"

class BlogBreadcrumbsTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Hello World", body: "Content")
  end

  test "blog index has breadcrumbs" do
    get blogs_path
    assert_response :success
    assert_select "nav.breadcrumbs" do
      assert_select "a[href=?]", root_path, text: "Home"
      assert_select "span", text: "Blog"
    end
  end

  test "blog show has breadcrumbs" do
    get blog_path(@blog)
    assert_response :success
    assert_select "nav.breadcrumbs" do
      assert_select "a[href=?]", root_path, text: "Home"
      assert_select "a[href=?]", blogs_path, text: "Blog"
      assert_select "span", text: "Hello World"
    end
  end
end
