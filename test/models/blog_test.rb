require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "estimated_reading_time returns 1 for 200 words" do
    blog = Blog.new(body: "word " * 200)
    assert_equal 1, blog.estimated_reading_time
  end

  test "estimated_reading_time returns 2 for 201 words" do
    blog = Blog.new(body: "word " * 201)
    assert_equal 2, blog.estimated_reading_time
  end

  test "estimated_reading_time returns 1 for small text" do
    blog = Blog.new(body: "Hello world")
    assert_equal 1, blog.estimated_reading_time
  end

  test "estimated_reading_time returns 0 for empty text" do
    blog = Blog.new(body: "")
    assert_equal 0, blog.estimated_reading_time
  end

  test "estimated_reading_time returns 0 for nil body" do
    blog = Blog.new(body: nil)
    assert_equal 0, blog.estimated_reading_time
  end
end
