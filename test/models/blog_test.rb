require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "is invalid without a title" do
    blog = Blog.new(title: "", body: "A useful post body.")

    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
  end

  test "is invalid without a body" do
    blog = Blog.new(title: "A useful title", body: "")

    assert_not blog.valid?
    assert_includes blog.errors[:body], "can't be blank"
  end

  test "is invalid with whitespace-only content" do
    blog = Blog.new(title: "   ", body: "\n\t  ")

    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
    assert_includes blog.errors[:body], "can't be blank"
  end

  test "is valid with title and body" do
    blog = Blog.new(title: "A useful title", body: "A useful post body.")

    assert blog.valid?
  end
end
