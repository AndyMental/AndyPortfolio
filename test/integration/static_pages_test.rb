require "test_helper"

class StaticPagesTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_url
    assert_response :success
    assert_select "h1", "About Me"
    assert_select "header nav" do
      assert_select "a", "Home"
      assert_select "a", "About"
    end
  end

  test "should have about link in header on home page" do
    get root_url
    assert_response :success
    assert_select "header nav" do
      assert_select "a", "About"
    end
  end
end
