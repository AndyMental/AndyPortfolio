require "test_helper"

class RobotsAndSitemapTest < ActionDispatch::IntegrationTest
  test "GET /robots.txt returns 200 text/plain with required directives" do
    get "/robots.txt"
    assert_response :success
    assert_match %r{text/plain}, @response.media_type
    body = @response.body
    assert_includes body, "User-agent: *"
    assert_includes body, "Allow: /"
    assert_includes body, "Sitemap:"
  end

  test "GET /sitemap.xml returns 200 application/xml listing home, blogs index, and each Blog" do
    blog_a = Blog.create!(title: "Sitemap post A", body: "<p>a</p>")
    blog_b = Blog.create!(title: "Sitemap post B", body: "<p>b</p>")

    get "/sitemap.xml"
    assert_response :success
    assert_equal "application/xml", @response.media_type

    body = @response.body
    assert_includes body, "<urlset"
    assert_includes body, root_url
    assert_includes body, blogs_url
    assert_includes body, blog_url(blog_a)
    assert_includes body, blog_url(blog_b)
  end
end
