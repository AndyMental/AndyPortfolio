require "test_helper"

class BlogPageTitlesTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Launch Notes", body: "<p>public body</p>")
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

  test "blog index has a distinct document title" do
    get blogs_path
    assert_response :success
    assert_select "title", "Blog | AndyPortfolio"
  end

  test "blog show title uses the post title" do
    get blog_path(@blog)
    assert_response :success
    assert_select "title", "Launch Notes | AndyPortfolio"
  end

  test "admin form pages have distinct document titles" do
    headers = { "X-Blog-Admin-Token" => "test-admin-token" }

    get new_blog_path, headers: headers
    assert_response :success
    assert_select "title", "New Blog | AndyPortfolio"

    get edit_blog_path(@blog), headers: headers
    assert_response :success
    assert_select "title", "Edit Launch Notes | AndyPortfolio"
  end
end
