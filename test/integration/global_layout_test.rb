require "test_helper"

class GlobalLayoutTest < ActionDispatch::IntegrationTest
  test "header and footer are present on home page" do
    get root_path
    assert_response :success

    assert_select "header" do
      assert_select "nav" do
        assert_select "a[href=?]", root_path, text: "AndyPortfolio"
      end
    end

    assert_select "footer" do
      assert_select "p", text: /Andy Mental/
      assert_select "a[href=?]", "https://github.com/AndyMental", text: "GitHub"
      assert_select "a[href=?]", "https://x.com/AndyMental", text: "X/Twitter"
    end
  end

  test "header and footer are present on blog show page" do
    # Create a blog post to test the show page
    # Note: This requires a working database connection
    blog = Blog.create!(title: "Test Post", body: "Body content")
    get blog_path(blog)
    assert_response :success

    assert_select "header"
    assert_select "footer"
  end
end
