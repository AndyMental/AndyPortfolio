require "test_helper"

class BlogSlugsTest < ActionDispatch::IntegrationTest
  test "blog paths use stable title slugs" do
    blog = Blog.create!(title: "Hello Rails World!", body: "<p>public body</p>")

    assert_equal "hello-rails-world", blog.slug
    assert_equal "/blogs/hello-rails-world", blog_path(blog)

    get "/blogs/hello-rails-world"
    assert_response :success
    assert_includes response.body, "Hello Rails World!"
  end

  test "duplicate titles receive unique slug suffixes" do
    first = Blog.create!(title: "Launch Notes", body: "First")
    second = Blog.create!(title: "Launch Notes", body: "Second")

    assert_equal "launch-notes", first.slug
    assert_equal "launch-notes-2", second.slug
  end

  test "slugs do not change when titles are updated" do
    blog = Blog.create!(title: "Original Title", body: "Body")

    blog.update!(title: "Renamed Title")

    assert_equal "original-title", blog.reload.slug
    get "/blogs/original-title"
    assert_response :success
    assert_includes response.body, "Renamed Title"
  end

  test "missing slug returns not found" do
    get "/blogs/not-a-real-post"

    assert_response :not_found
  end

  test "reserved new slug is skipped" do
    blog = Blog.create!(title: "New", body: "Body")

    assert_equal "new-2", blog.slug
    assert_equal "/blogs/new-2", blog_path(blog)
  end
end
