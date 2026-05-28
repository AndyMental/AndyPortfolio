require "test_helper"

class BlogAdminGateTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Visible post", body: "<p>hello</p>")
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

  test "anonymous visitor can read index and show" do
    get blogs_path
    assert_response :success

    get blog_path(@blog)
    assert_response :success
  end

  test "anonymous index hides New blog control" do
    get blogs_path
    assert_response :success
    assert_no_match(/New blog/, response.body)
  end

  test "anonymous index presents posts as read-only articles" do
    get blogs_path
    assert_response :success

    assert_select "header nav a", text: "AndyPortfolio"
    assert_select "article.blog-card h2 a", text: @blog.title
    assert_select "a[aria-label=?]", "Read #{@blog.title}"
  end

  test "anonymous index renders empty state" do
    Blog.delete_all

    get blogs_path
    assert_response :success

    assert_select "article.empty-state h2", text: "No posts yet"
    assert_no_match(/New blog/, response.body)
  end

  test "anonymous show hides Edit and Destroy controls" do
    get blog_path(@blog)
    assert_response :success
    assert_no_match(/Edit this blog/, response.body)
    assert_no_match(/Destroy this blog/, response.body)
  end

  test "anonymous show has blog navigation and article body" do
    get blog_path(@blog)
    assert_response :success

    assert_select "a", text: "Back to blog"
    assert_select "article.blog-post h1", text: @blog.title
    assert_select "article.blog-post .blog-body p", text: "hello"
  end

  test "anonymous write actions return 404" do
    get new_blog_path
    assert_response :not_found

    get edit_blog_path(@blog)
    assert_response :not_found

    post blogs_path, params: { blog: { title: "x", body: "y" } }
    assert_response :not_found
    assert_equal 1, Blog.count

    patch blog_path(@blog), params: { blog: { title: "tampered" } }
    assert_response :not_found
    assert_equal "Visible post", @blog.reload.title

    delete blog_path(@blog)
    assert_response :not_found
    assert Blog.exists?(@blog.id)
  end

  test "admin token unlocks write actions and surfaces controls" do
    headers = { "X-Blog-Admin-Token" => "test-admin-token" }

    get blogs_path, headers: headers
    assert_response :success
    assert_match(/New blog/, response.body)

    get blog_path(@blog), headers: headers
    assert_response :success
    assert_match(/Edit this blog/, response.body)
    assert_match(/Destroy this blog/, response.body)

    post blogs_path,
      params: { blog: { title: "Admin post", body: "<p>body</p>" } },
      headers: headers
    assert_response :redirect
    assert_equal 2, Blog.count
  end

  test "wrong admin token still blocks writes" do
    headers = { "X-Blog-Admin-Token" => "nope" }

    get new_blog_path, headers: headers
    assert_response :not_found

    delete blog_path(@blog), headers: headers
    assert_response :not_found
    assert Blog.exists?(@blog.id)
  end

  test "missing BLOG_ADMIN_TOKEN env keeps writes locked" do
    ENV.delete("BLOG_ADMIN_TOKEN")
    headers = { "X-Blog-Admin-Token" => "anything" }

    post blogs_path,
      params: { blog: { title: "x", body: "y" } },
      headers: headers
    assert_response :not_found
  end
end
