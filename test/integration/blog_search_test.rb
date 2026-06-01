require "test_helper"

class BlogSearchTest < ActionDispatch::IntegrationTest
  setup do
    @blog1 = Blog.create!(title: "Ruby on Rails", body: "Rails is a web framework.")
    @blog2 = Blog.create!(title: "Python Django", body: "Django is another framework.")
  end

  test "searching for keyword in title" do
    get blogs_path(q: "Ruby")
    assert_response :success
    assert_includes response.body, "Ruby on Rails"
    refute_includes response.body, "Python Django"
  end

  test "searching for keyword in body" do
    get blogs_path(q: "another")
    assert_response :success
    assert_includes response.body, "Python Django"
    refute_includes response.body, "Ruby on Rails"
  end

  test "searching with no results" do
    get blogs_path(q: "Nonexistent")
    assert_response :success
    assert_includes response.body, "No posts yet"
  end
end
