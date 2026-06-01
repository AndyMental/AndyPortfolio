require "test_helper"

class AccessibilitySmokeTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Accessible Rails post", body: "<p>Readable body.</p>")
    @prior_token = ENV["BLOG_ADMIN_TOKEN"]
    ENV["BLOG_ADMIN_TOKEN"] = "test-admin-token"
  end

  teardown do
    if @prior_token.nil?
      ENV.delete("BLOG_ADMIN_TOKEN")
    else
      ENV["BLOG_ADMIN_TOKEN"] = @prior_token
    end
  end

  test "public HTML pages expose baseline document landmarks" do
    [
      [root_path, "Blogs"],
      [about_path, "About Andy Mental"],
      [blogs_path, "Blogs"],
      [blog_path(@blog), @blog.title]
    ].each do |path, heading|
      get path

      assert_response :success
      assert_select "html[lang='en']", 1
      assert_select "meta[name='viewport'][content='width=device-width,initial-scale=1']", 1
      assert_select "header nav a[href='#{root_path}']", "Home"
      assert_select "header nav a[href='#{about_path}']", "About"
      assert_select "header nav a[href='#{blogs_path}']", "Blog"
      assert_select "main", 1
      assert_select "main h1", 1
      assert_select "main h1", heading
      assert_select "footer", /Andy Mental/
    end
  end

  test "blog search exposes a label and status region for no results" do
    get blogs_path(q: "missing")

    assert_response :success
    assert_select "form.search-form label[for='q']", "Search blogs:"
    assert_select "form.search-form input#q[name='q']", 1
    assert_select "section[role='status'][aria-live='polite'] h2", "No matching posts"
  end

  test "anonymous public pages hide admin-only controls" do
    get blogs_path

    assert_response :success
    assert_select "a[href='#{new_blog_path}']", 0

    get blog_path(@blog)

    assert_response :success
    assert_select "a[href='#{edit_blog_path(@blog)}']", 0
    assert_select "form[action='#{blog_path(@blog)}']", 0
  end

  test "admin blog forms expose labels for editable fields" do
    headers = { "X-Blog-Admin-Token" => "test-admin-token" }

    get new_blog_path, headers: headers

    assert_response :success
    assert_select "main h1", "New blog"
    assert_select "label[for='blog_title']", "Title"
    assert_select "input#blog_title[name='blog[title]']", 1
    assert_select "label[for='blog_body']", "Body"
    assert_select "textarea#blog_body[name='blog[body]']", 1

    get edit_blog_path(@blog), headers: headers

    assert_response :success
    assert_select "main h1", "Editing Blog"
    assert_select "label[for='blog_title']", "Title"
    assert_select "input#blog_title[name='blog[title]']", 1
    assert_select "label[for='blog_body']", "Body"
    assert_select "textarea#blog_body[name='blog[body]']", 1
  end

  test "non UI public endpoints keep expected response shapes" do
    get "/up"
    assert_response :success
    assert_equal "text/plain", @response.media_type

    get "/sitemap.xml"
    assert_response :success
    assert_equal "application/xml", @response.media_type

    get "/robots.txt"
    assert_response :success
    assert_match %r{text/plain}, @response.media_type
  end
end
