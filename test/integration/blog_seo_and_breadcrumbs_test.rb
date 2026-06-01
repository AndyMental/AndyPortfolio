require "test_helper"

class BlogSeoAndBreadcrumbsTest < ActionDispatch::IntegrationTest
  setup do
    @original_token = ENV["BLOG_ADMIN_TOKEN"]
    @blog = Blog.create!(title: "SEO Test Post", body: "<p>This is a test post for SEO and breadcrumbs.</p>")
  end

  teardown do
    ENV["BLOG_ADMIN_TOKEN"] = @original_token
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

  test "breadcrumbs correctly escape HTML in title" do
    xss_blog = Blog.create!(title: "<script>alert('xss')</script>", body: "xss test")
    get blog_path(xss_blog)
    assert_response :success
    assert_select "nav[aria-label='Breadcrumb'] p" do
      assert_match /&lt;script&gt;alert\(&#39;xss&#39;\)&lt;\/script&gt;/, response.body
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
