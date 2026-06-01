require "test_helper"

class BlogReadingTimeTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Test Blog", body: "word " * 201)
  end

  test "should show estimated reading time on index" do
    get blogs_url
    assert_response :success
    assert_select "p", text: /Estimated Reading Time:\s+2 min/
  end

  test "should show estimated reading time on show" do
    get blog_url(@blog)
    assert_response :success
    assert_select "p", text: /Estimated Reading Time:\s+2 min/
  end
end
