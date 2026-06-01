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

  test "blogs are ordered by created_at desc and id desc" do
    # Create blogs with different created_at
    old_blog = Blog.create!(title: "Old Blog", body: "Old body", created_at: 2.days.ago)
    new_blog = Blog.create!(title: "New Blog", body: "New body", created_at: 1.day.ago)

    # Create two blogs with identical created_at to test ID tie-breaker
    now = Time.current
    blog_a = Blog.create!(title: "Blog A", body: "Body A", created_at: now)
    blog_b = Blog.create!(title: "Blog B", body: "Body B", created_at: now)
    # blog_b should have a higher ID than blog_a if created after

    get blogs_path
    assert_response :success

    # Expectation: blog_b, blog_a, new_blog, old_blog (smoke check post from other tests might be there too)
    # We check the relative order in the response body.
    # Since they are rendered in order, we can check their positions.
    
    body = response.body
    pos_b = body.index("Blog B")
    pos_a = body.index("Blog A")
    pos_new = body.index("New Blog")
    pos_old = body.index("Old Blog")

    assert pos_b < pos_a, "Blog B (higher ID) should be before Blog A (lower ID) when created_at is same"
    assert pos_a < pos_new, "Blog A (newer) should be before New Blog (older)"
    assert pos_new < pos_old, "New Blog (newer) should be before Old Blog (older)"
  end
end
