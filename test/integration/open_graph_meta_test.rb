require "test_helper"

class OpenGraphMetaTest < ActionDispatch::IntegrationTest
  setup do
    @blog = Blog.create!(title: "Launch Notes", body: "<p>public body</p>")
  end

  test "home page has correct meta tags" do
    get root_path
    assert_response :success
    
    assert_select "title", "Blog | AndyPortfolio"
    assert_select "meta[name='description'][content=?]", "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase."
    
    assert_select "meta[property='og:type'][content='website']"
    assert_select "meta[property='og:title'][content='Blog']"
    assert_select "meta[property='og:description'][content=?]", "Andy Mental's portfolio — a Rails-backed blog companion to the andy-portfolio.com showcase."
    assert_select "meta[property='og:site_name'][content='AndyPortfolio']"
    
    assert_select "meta[property='twitter:card'][content='summary_large_image']"
    assert_select "meta[property='twitter:title'][content='Blog']"
  end

  test "blog show page has correct meta tags" do
    get blog_path(@blog)
    assert_response :success
    
    assert_select "title", "Launch Notes | AndyPortfolio"
    
    # og:title should NOT have the site name suffix
    assert_select "meta[property='og:title'][content='Launch Notes']"
    assert_select "meta[property='twitter:title'][content='Launch Notes']"
  end
end
