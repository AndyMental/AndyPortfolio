require "test_helper"

class BlogBodyRenderingTest < ActionDispatch::IntegrationTest
  test "blog body strips unsafe markup and preserves basic formatting" do
    blog = Blog.create!(
      title: "Sanitizer check",
      body: <<~HTML
        <script>alert("xss")</script>
        <p onclick="alert('xss')">Hello <strong>safe</strong> <em>formatting</em></p>
        <a href="javascript:alert('xss')" onmouseover="alert('xss')">bad link</a>
        <img src=x onerror="alert('xss')">
      HTML
    )

    get blog_path(blog)

    assert_response :success
    assert_no_match(/<script/i, response.body)
    assert_no_match(/onclick=/i, response.body)
    assert_no_match(/onmouseover=/i, response.body)
    assert_no_match(/onerror=/i, response.body)
    assert_no_match(/<img/i, response.body)
    assert_no_match(/javascript:/i, response.body)
    assert_includes response.body, "<strong>safe</strong>"
    assert_includes response.body, "<em>formatting</em>"
  end
end
