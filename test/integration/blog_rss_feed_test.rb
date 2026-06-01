require "test_helper"

class BlogRssFeedTest < ActionDispatch::IntegrationTest
  test "GET /blogs.rss returns valid RSS feed" do
    blog = Blog.create!(title: "RSS test post", body: "This is the body of the RSS test post.")

    get blogs_path(format: :rss)
    assert_response :success
    assert_equal "application/rss+xml; charset=utf-8", @response.header["Content-Type"]

    body = @response.body
    assert_includes body, "<rss version=\"2.0\""
    assert_includes body, "<title>Andy Mental's Blog</title>"
    assert_includes body, "<title>#{blog.title}</title>"
    assert_includes body, "<![CDATA[#{blog.body}]]>"
    assert_includes body, blog_url(blog)
  end

  test "layout includes RSS discovery link" do
    get blogs_path
    assert_response :success
    assert_select "link[rel='alternate'][type='application/rss+xml'][href=?]", blogs_url(format: :rss)
  end

  test "index page includes RSS link" do
    get blogs_path
    assert_response :success
    assert_select "a[href=?]", blogs_path(format: :rss), text: "RSS Feed"
  end
end
