require "test_helper"

class BlogsIndexTest < ActionDispatch::IntegrationTest
  test "root and blogs index render public blog list" do
    blog = Blog.create!(title: "Smoke check post", body: "<p>public body</p>")

    get root_path
    assert_response :success

    get blogs_path
    assert_response :success
    assert_includes response.body, blog.title
  end
end
