require "test_helper"

class StaticPagesTest < ActionDispatch::IntegrationTest
  test "about page is reachable" do
    get about_url

    assert_response :success
    assert_select "h1", "About Andy Mental"
    assert_select "main p", text: /software engineer/
  end

  test "header links to about page" do
    get root_url

    assert_response :success
    assert_select "header nav a[href='#{about_path}']", "About"
  end
end
