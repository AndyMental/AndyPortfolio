require "test_helper"

class StaticIconsTest < ActionDispatch::IntegrationTest
  test "GET /favicon.ico returns 200" do
    get "/favicon.ico"
    assert_response :success
  end

  test "GET /apple-touch-icon.png returns 200" do
    get "/apple-touch-icon.png"
    assert_response :success
  end

  test "layout includes favicon and apple-touch-icon links" do
    get root_path
    assert_response :success
    assert_select "link[rel='icon'][href='/favicon.ico']"
    assert_select "link[rel='apple-touch-icon'][href='/apple-touch-icon.png']"
  end
end
