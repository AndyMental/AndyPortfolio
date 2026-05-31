require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "up returns a plain health response" do
    get up_path

    assert_response :success
    assert_equal "OK", response.body
  end
end
