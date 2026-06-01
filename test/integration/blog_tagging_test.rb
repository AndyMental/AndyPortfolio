require "test_helper"

class BlogTaggingTest < ActionDispatch::IntegrationTest
  setup do
    @admin_token = "test-token"
    ENV["BLOG_ADMIN_TOKEN"] = @admin_token
  end

  test "can create blog with tags" do
    assert_difference("Blog.count") do
      post blogs_url, params: { blog: { title: "Tagged Post", body: "Content", tags: "ruby, rails" } },
                     headers: { "X-Blog-Admin-Token" => @admin_token }
    end

    blog = Blog.last
    assert_equal "ruby, rails", blog.tags
    assert_equal ["ruby", "rails"], blog.tag_list
  end

  test "can filter blogs by tag" do
    Blog.create!(title: "Ruby Post", body: "Content", tags: "ruby")
    Blog.create!(title: "Rails Post", body: "Content", tags: "rails")
    Blog.create!(title: "Both Post", body: "Content", tags: "ruby, rails")

    get blogs_url(tag: "ruby")
    assert_response :success
    assert_select "h2", text: "Ruby Post"
    assert_select "h2", text: "Both Post"
    assert_select "h2", text: "Rails Post", count: 0

    get blogs_url(tag: "rails")
    assert_response :success
    assert_select "h2", text: "Rails Post"
    assert_select "h2", text: "Both Post"
    assert_select "h2", text: "Ruby Post", count: 0
  end

  test "displays tags on index and show pages" do
    blog = Blog.create!(title: "Tagged Post", body: "Content", tags: "ruby, rails")

    get blogs_url
    assert_select "small", text: /Tags:.*ruby.*rails/

    get blog_url(blog)
    assert_select "small", text: /Tags:.*ruby.*rails/
  end
end
