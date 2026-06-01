require "test_helper"

class BlogSeoAndBreadcrumbsTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "SEO Test Post", body: "<p>This is a test post for SEO and breadcrumbs.</p>")
  end

  test "show page has OpenGraph and Twitter tags" do
    get blog_path(@blog)
    assert_response :success

    # Meta description
    assert_select "meta[name='description'][content='This is a test post for SEO and breadcrumbs.']"

    # OpenGraph tags
    assert_select "meta[property='og:title'][content='SEO Test Post | AndyPortfolio']"
    assert_select "meta[property='og:description'][content='This is a test post for SEO and breadcrumbs.']"
    assert_select "meta[property='og:type'][content='website']"

    # Twitter tags
    assert_select "meta[property='twitter:title'][content='SEO Test Post | AndyPortfolio']"
    assert_select "meta[property='twitter:description'][content='This is a test post for SEO and breadcrumbs.']"
  end

  test "index page has default SEO tags" do
    get blogs_path
    assert_response :success

    assert_select "meta[name='description'][content='Read the latest updates and articles from Andy Mental.']"
    assert_select "meta[property='og:title'][content='Blog | AndyPortfolio']"
  end

  test "breadcrumbs are present on show page" do
    get blog_path(@blog)
    assert_response :success

    assert_select "nav[aria-label='Breadcrumb']" do
      assert_select "a[href='/']", text: "Home"
      assert_select "a[href='/blogs']", text: "Blog"
      assert_select "p", text: /Home.*Blog.*SEO Test Post/
    end
  end

  test "breadcrumbs are present on new page" do
    ENV["BLOG_ADMIN_TOKEN"] = "test-token"
    get new_blog_path, headers: { "X-Blog-Admin-Token" => "test-token" }
    assert_response :success

    assert_select "nav[aria-label='Breadcrumb']" do
      assert_select "a[href='/']", text: "Home"
      assert_select "a[href='/blogs']", text: "Blog"
      assert_select "p", text: /Home.*Blog.*New Blog/
    end
  end

  test "header contains navigation" do
    get blogs_path
    assert_select "header nav" do
      assert_select "a[href='/']", text: "Home"
      assert_select "a[href='/blogs']", text: "Blog"
    end
  end
end
