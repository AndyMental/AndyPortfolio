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

  test "blogs are ordered by created_at desc" do
    # Create two blogs with distinct timestamps
    older_blog = Blog.create!(title: "Older Blog", body: "Older body", created_at: 1.day.ago)
    newer_blog = Blog.create!(title: "Newer Blog", body: "Newer body", created_at: Time.current)

    get blogs_path
    assert_response :success
    
    # Assert newer blog appears before older blog in the response body
    body = response.body
    newer_index = body.index(newer_blog.title)
    older_index = body.index(older_blog.title)
    
    assert_not_nil newer_index, "Newer blog title not found in response"
    assert_not_nil older_index, "Older blog title not found in response"
    assert newer_index < older_index, "Newer blog should appear before older blog in the list"
  end
end
