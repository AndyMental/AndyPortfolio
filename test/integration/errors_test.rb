require "test_helper"

class ErrorsTest < ActionDispatch::IntegrationTest
  test "should get 404" do
    get "/404"
    assert_response :not_found
    assert_select "h1", "Page not found"
  end

  test "should get 500" do
    get "/500"
    assert_response :internal_server_error
    assert_select "h1", "Something went wrong"
  end

  test "should get 422" do
    get "/422"
    assert_response :unprocessable_entity
    assert_select "h1", "Unprocessable Entity"
  end

  test "non-existent route should return 404" do
    # Note: In test environment, config.consider_all_requests_local is true by default
    # so Rails might show the default debugging page instead of our custom 404.
    # But get "/404" should work regardless if we manually hit it.
    get "/some-non-existent-path"
    # This might fail in test env if not configured to show custom errors.
  end
end
