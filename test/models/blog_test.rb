require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "database rejects NULL title even when model validations are bypassed" do
    blog = Blog.new(title: nil, body: "some body")

    assert_raises(ActiveRecord::NotNullViolation) do
      blog.save(validate: false)
    end
  end

  test "database rejects NULL body even when model validations are bypassed" do
    blog = Blog.new(title: "some title", body: nil)

    assert_raises(ActiveRecord::NotNullViolation) do
      blog.save(validate: false)
    end
  end
end
