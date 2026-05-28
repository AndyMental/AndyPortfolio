require "test_helper"

class BlogBodyRenderingTest < ActionDispatch::IntegrationTest
  test "blog body strips unsafe markup and preserves basic formatting" do
    blog = Blog.create!(
      title: "Sanitizer check",
      body: <<~HTML
        <script>alert("xss")</script>
        <p onclick="alert('xss')">Hello <strong>safe</strong> <em>formatting</em></p>
        <a href="javascript:alert('xss')" onmouseover="alert('xss')">bad link</a>
        <img src="x" onerror="alert('xss')" alt="ok">
      HTML
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id}" do
      assert_select "script", false
      assert_select "[onclick]", false
      assert_select "[onmouseover]", false
      assert_select "[onerror]", false
      assert_select "a[href^='javascript:']", false
      assert_select "strong", text: "safe"
      assert_select "em", text: "formatting"
      assert_select "img[src='x'][alt='ok']"
    end
  end

  test "blog body fills missing image alt text using the blog title" do
    blog = Blog.create!(
      title: "Launch Notes",
      body: '<p><img src="hero.jpg"></p>'
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id} img[src='hero.jpg'][alt='Image from Launch Notes']"
  end

  test "blog body replaces blank image alt text using the blog title" do
    blog = Blog.create!(
      title: "Launch Notes",
      body: '<p><img src="hero.jpg" alt=""></p>'
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id} img[src='hero.jpg'][alt='Image from Launch Notes']"
  end

  test "blog body preserves author-provided image alt text" do
    blog = Blog.create!(
      title: "Launch Notes",
      body: '<p><img src="hero.jpg" alt="Prototype dashboard"></p>'
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id} img[src='hero.jpg'][alt='Prototype dashboard']"
  end

  test "blog body uses generic alt text when title is blank" do
    blog = Blog.create!(
      title: " ",
      body: '<p><img src="hero.jpg"></p>'
    )

    get blog_path(blog)

    assert_response :success
    assert_select "div#blog_#{blog.id} img[src='hero.jpg'][alt='Blog image']"
  end
end
