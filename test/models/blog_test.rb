require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "requires title" do
    blog = Blog.new(title: "", body: "Published body")

    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
  end

  test "requires body" do
    blog = Blog.new(title: "Published title", body: "")

    assert_not blog.valid?
    assert_includes blog.errors[:body], "can't be blank"
  end

  test "rejects whitespace-only title and body" do
    blog = Blog.new(title: "   ", body: "\n\t")

    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
    assert_includes blog.errors[:body], "can't be blank"
  end

  test "is valid with title and body" do
    blog = Blog.new(title: "Published title", body: "Published body")

    assert blog.valid?
  end
end
