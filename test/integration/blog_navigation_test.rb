require "test_helper"

class BlogNavigationTest < ActionDispatch::IntegrationTest
  setup do
    @admin_token = "test-token"
    ENV["BLOG_ADMIN_TOKEN"] = @admin_token
  end

  test "blog show page has 'Back to Blog' link" do
    blog = Blog.create!(title: "Navigation test post", body: "<p>test body</p>")
    get blog_path(blog)
    assert_response :success
    assert_select "a[href=?]", blogs_path, text: "Back to Blog"
  end

  test "blog new page has 'Back to Blog' link" do
    get new_blog_path, headers: { "X-Blog-Admin-Token" => @admin_token }
    assert_response :success
    assert_select "a[href=?]", blogs_path, text: "Back to Blog"
  end

  test "blog edit page has 'Back to Blog' link" do
    blog = Blog.create!(title: "Edit navigation test post", body: "<p>test body</p>")
    get edit_blog_path(blog), headers: { "X-Blog-Admin-Token" => @admin_token }
    assert_response :success
    assert_select "a[href=?]", blogs_path, text: "Back to Blog"
  end
end
