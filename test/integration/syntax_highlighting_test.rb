require "test_helper"

class SyntaxHighlightingTest < ActionDispatch::IntegrationTest
  test "blog body preserves pre and code tags and class attribute" do
    blog = Blog.create!(
      title: "Syntax Highlighting Test",
      body: <<~HTML
        <p>Check out this code:</p>
        <pre><code class="language-ruby">puts "Hello World"</code></pre>
      HTML
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id}" do
      assert_select "pre" do
        assert_select "code.language-ruby", text: 'puts "Hello World"'
      end
    end
  end

  test "layout includes Prism.js from CDN" do
    blog = Blog.create!(title: "Prism Test", body: "test")
    get blog_path(blog)

    assert_select "head link[href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css']", 1
    assert_select "head script[src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js']", 1
  end
end
