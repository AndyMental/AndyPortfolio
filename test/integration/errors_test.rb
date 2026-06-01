require "test_helper"

class ErrorsTest < ActionDispatch::IntegrationTest
  setup do
    # Enable custom error pages for these tests
    Rails.application.config.consider_all_requests_local = false
    Rails.application.config.action_dispatch.show_exceptions = true
  end

  teardown do
    # Restore defaults
    Rails.application.config.consider_all_requests_local = true
    Rails.application.config.action_dispatch.show_exceptions = false
  end

  test "should get 404 for non-existent page" do
    get "/this-page-does-not-exist"
    assert_response :not_found
    assert_select "h1", "Page not found"
    assert_select "title", "Page not found | AndyPortfolio"
  end

  test "should get 500 for server error" do
    # Mock BlogsController to raise an error
    BlogsController.any_instance.stubs(:index).raises(StandardError, "Server Error")
    
    get root_path
    assert_response :internal_server_error
    assert_select "h1", "Internal Server Error"
    assert_select "title", "Internal Server Error | AndyPortfolio"
  end

  test "should get 422 for unprocessable entity" do
    # Mock BlogsController to raise a 422 error
    # ActionController::InvalidAuthenticityToken is mapped to 422
    BlogsController.any_instance.stubs(:index).raises(ActionController::InvalidAuthenticityToken)
    
    get root_path
    assert_response :unprocessable_entity
    assert_select "h1", "Unprocessable Entity"
    assert_select "title", "Unprocessable Entity | AndyPortfolio"
  end
end
