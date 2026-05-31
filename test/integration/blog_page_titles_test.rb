require "test_helper"

class BlogPageTitlesTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Test Blog Post", body: "Test body")
  end

  test "blog index has correct title" do
    get blogs_path
    assert_response :success
    assert_select "title", "Blog | AndyPortfolio"
  end

  test "blog show has correct title" do
    get blog_path(@blog)
    assert_response :success
    assert_select "title", "#{@blog.title} | AndyPortfolio"
  end

  test "new blog has correct title" do
    get new_blog_path
    assert_response :success
    assert_select "title", "New blog | AndyPortfolio"
  end

  test "edit blog has correct title" do
    get edit_blog_path(@blog)
    assert_response :success
    assert_select "title", "Editing blog | AndyPortfolio"
  end
end
