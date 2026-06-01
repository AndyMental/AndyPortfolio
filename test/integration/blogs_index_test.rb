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
    # We use explicit created_at to ensure order for the test
    21.times do |i|
      Blog.create!(title: "Blog Post #{i}", body: "Body for blog post #{i}", created_at: i.hours.ago)
    end

    get blogs_path
    assert_response :success

    # Check for the first page posts
    assert_select "div#blogs" do
      assert_select "div[id^='blog_']", count: 20
      # The first blog (newest) should be "Blog Post 0" because it was created 0 hours ago
      assert_select "div[id^='blog_']", text: /Blog Post 0/, count: 1
    end

    # Check for pagination nav
    assert_select "nav.pagy-nav"

    # Go to second page
    get blogs_path(page: 2)
    assert_response :success
    assert_select "div#blogs" do
      assert_select "div[id^='blog_']", count: 1
      # The last blog (oldest) should be "Blog Post 20"
      assert_select "div[id^='blog_']", text: /Blog Post 20/, count: 1
    end
  end
end
