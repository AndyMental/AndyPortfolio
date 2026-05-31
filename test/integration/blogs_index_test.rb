require "test_helper"

class BlogsIndexTest < ActionDispatch::IntegrationTest
  test "root and blogs index render public blog list" do
    blog = Blog.create!(title: "Smoke check post", body: "<p>public body</p>")

    get root_path
    assert_response :success

    get blogs_path
    assert_response :success
    assert_includes response.body, blog.title
  end

  test "blogs index pagination" do
    # Create enough blogs to trigger pagination (default is 20 per page)
    21.times do |i|
      Blog.create!(title: "Blog Post #{i}", body: "Body for blog post #{i}")
    end

    get blogs_path
    assert_response :success

    # Check for the first page posts
    assert_select "div#blogs" do
      assert_select "div[id^='blog_']", count: 20
    end

    # Check for pagination nav
    assert_select "nav.pagy-nav"

    # Go to second page
    get blogs_path(page: 2)
    assert_response :success
    assert_select "div#blogs" do
      assert_select "div[id^='blog_']", count: 1
    end
  end
end
