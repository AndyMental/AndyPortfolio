require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "should be valid with title and body" do
    blog = Blog.new(title: "Test Title", body: "Test Body")
    assert blog.valid?
  end

  test "should be invalid without title" do
    blog = Blog.new(body: "Test Body")
    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
  end

  test "should be invalid without body" do
    blog = Blog.new(title: "Test Title")
    assert_not blog.valid?
    assert_includes blog.errors[:body], "can't be blank"
  end
end
