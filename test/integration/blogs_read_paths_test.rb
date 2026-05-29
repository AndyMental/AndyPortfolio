require "test_helper"

class BlogsReadPathsTest < ActionDispatch::IntegrationTest
  test "GET / renders the blogs#index layout" do
    get root_path
    assert_response :success
    assert_select "h1", text: "Blogs"
  end

  test "GET /blogs renders the blogs#index layout when posts exist" do
    Blog.create!(title: "Read path post", body: "<p>read body</p>")

    get blogs_path
    assert_response :success
    assert_select "h1", text: "Blogs"
    assert_select "div#blogs"
  end

  test "GET /blogs lists every Blog in Blog.all order" do
    first  = Blog.create!(title: "First read path post",  body: "<p>one</p>")
    second = Blog.create!(title: "Second read path post", body: "<p>two</p>")
    third  = Blog.create!(title: "Third read path post",  body: "<p>three</p>")

    expected_titles = Blog.all.pluck(:title)
    assert_includes expected_titles, first.title
    assert_includes expected_titles, second.title
    assert_includes expected_titles, third.title

    get blogs_path
    assert_response :success

    positions = expected_titles.map { |t| response.body.index(t) }
    assert positions.all?, "expected every Blog.all title to appear in /blogs body, got positions=#{positions.inspect}"
    assert_equal positions.sort, positions, "expected titles to render in Blog.all order, got positions=#{positions.inspect} for #{expected_titles.inspect}"
  end

  test "GET /blogs/:id for an existing record renders the blog body fragment" do
    blog = Blog.create!(
      title: "Body fragment post",
      body: "<p>fragment <strong>body</strong> content</p>"
    )

    get blog_path(blog)
    assert_response :success
    assert_select "div#blog_#{blog.id}" do
      assert_select "p", text: /fragment/
      assert_select "strong", text: "body"
    end
  end

  test "GET /blogs/:id for a nonexistent id raises ActiveRecord::RecordNotFound" do
    missing_id = (Blog.maximum(:id) || 0) + 10_000

    assert_raises(ActiveRecord::RecordNotFound) do
      get blog_path(id: missing_id)
    end
  end
end
