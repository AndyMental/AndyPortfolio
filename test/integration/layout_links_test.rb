require "test_helper"

class LayoutLinksTest < ActionDispatch::IntegrationTest
  test "root navigation marks only home as current" do
    get root_url

    assert_response :success
    assert_select "header nav a.current[aria-current='page'][href='#{root_path}']", "Home"
    assert_select "header nav a.current[aria-current='page'][href='#{about_path}']", 0
    assert_select "header nav a.current[aria-current='page'][href='#{blogs_path}']", 0
  end

  test "about navigation marks about as current" do
    get about_url

    assert_response :success
    assert_select "header nav a.current[aria-current='page'][href='#{about_path}']", "About"
    assert_select "header nav a.current[aria-current='page'][href='#{root_path}']", 0
  end

  test "blog navigation remains current on blog subpaths" do
    blog = Blog.create!(title: "Active navigation post", body: "<p>Readable body.</p>")

    get blog_url(blog)

    assert_response :success
    assert_select "header nav a.current[aria-current='page'][href='#{blogs_path}']", "Blog"
    assert_select "header nav a.current[aria-current='page'][href='#{root_path}']", 0
  end

  test "footer includes safe visible social links" do
    get root_url

    assert_response :success
    assert_select "footer a[href='https://www.linkedin.com/in/andymental/'][target='_blank'][rel='noopener noreferrer']", "LinkedIn"
    assert_select "footer a[href='https://github.com/AndyMental'][target='_blank'][rel='noopener noreferrer']", "GitHub"
  end
end
