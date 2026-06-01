require "test_helper"

class ErrorsTest < ActionDispatch::IntegrationTest
  setup do
    @original_show_exceptions = Rails.application.env_config["action_dispatch.show_exceptions"]
    @original_show_detailed  = Rails.application.env_config["action_dispatch.show_detailed_exceptions"]
    Rails.application.env_config["action_dispatch.show_exceptions"] = :all
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false
  end

  teardown do
    Rails.application.env_config["action_dispatch.show_exceptions"] = @original_show_exceptions
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = @original_show_detailed
  end

  test "should get 404 for non-existent page" do
    get "/this-page-does-not-exist", env: { "action_dispatch.show_exceptions" => :all }
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
