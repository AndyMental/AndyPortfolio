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
    assert_select "article#blog_#{blog.id}" do
      assert_select "script", false
      assert_select "[onclick]", false
      assert_select "[onmouseover]", false
      assert_select "[onerror]", false
      assert_select "img", false
      assert_select "a[href^='javascript:']", false
      assert_select "strong", text: "safe"
      assert_select "em", text: "formatting"
    end
  end
end
