require "test_helper"

class AccessibilityTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "A11y Test Blog", body: "Checking accessibility attributes.")
  end

  test "navigation links have aria-current when on the respective page" do
    # Home
    get root_path
    assert_select "header nav a[href=?][aria-current='page']", root_path, text: "Home"
    assert_select "header nav a[href=?]:not([aria-current])", about_path, text: "About"
    assert_select "header nav a[href=?]:not([aria-current])", blogs_path, text: "Blog" # Should not be active on root

    # About
    get about_path
    assert_select "header nav a[href=?]:not([aria-current])", root_path, text: "Home"
    assert_select "header nav a[href=?][aria-current='page']", about_path, text: "About"
    assert_select "header nav a[href=?]:not([aria-current])", blogs_path, text: "Blog"

    # Blog index
    get blogs_path
    assert_select "header nav a[href=?]:not([aria-current])", root_path, text: "Home"
    assert_select "header nav a[href=?][aria-current='page']", blogs_path, text: "Blog"
  end

  test "breadcrumbs have proper accessibility attributes" do
    get blog_path(@blog)
    assert_response :success
    assert_select "nav.breadcrumbs" do
      # Separators hidden
      assert_select "span[aria-hidden='true']", text: ">"
      # Current page indicator
      assert_select "span[aria-current='page']", text: "A11y Test Blog"
      # Other links
      assert_select "a[href=?]:not([aria-current])", root_path, text: "Home"
      assert_select "a[href=?]:not([aria-current])", blogs_path, text: "Blog"
    end
    
    get blogs_path
    assert_select "nav.breadcrumbs" do
      assert_select "a[href=?]:not([aria-current])", root_path, text: "Home"
      assert_select "span[aria-current='page']", text: "Blog"
    end
  end
end
