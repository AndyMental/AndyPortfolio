require "test_helper"

class OpenGraphMetaTest < ActionDispatch::IntegrationTest
  test "root renders OpenGraph and Twitter Card meta tags" do
    get root_path
    assert_response :success

    assert_select "meta[property=?]", "og:title"
    assert_select "meta[property=?]", "og:description"
    assert_select "meta[property=?][content=?]", "og:type", "website"
    assert_select "meta[property=?]", "og:url"
    assert_select "meta[name=?][content=?]", "twitter:card", "summary"
    assert_select "meta[name=?]", "twitter:title"
    assert_select "meta[name=?]", "twitter:description"
  end

  test "blogs index renders OpenGraph and Twitter Card meta tags" do
    get blogs_path
    assert_response :success

    assert_select "meta[property=?]", "og:title"
    assert_select "meta[property=?]", "og:description"
    assert_select "meta[property=?][content=?]", "og:type", "website"
    assert_select "meta[property=?]", "og:url"
    assert_select "meta[name=?][content=?]", "twitter:card", "summary"
    assert_select "meta[name=?]", "twitter:title"
    assert_select "meta[name=?]", "twitter:description"
  end

  test "blog show overrides og:type to article" do
    blog = Blog.create!(title: "Launch notes", body: "<p>public body</p>")

    get blog_path(blog)
    assert_response :success

    assert_select "meta[property=?][content=?]", "og:type", "article"
    assert_select "meta[property=?]", "og:title"
    assert_select "meta[property=?]", "og:description"
    assert_select "meta[property=?]", "og:url"
    assert_select "meta[name=?][content=?]", "twitter:card", "summary"
  end
end
