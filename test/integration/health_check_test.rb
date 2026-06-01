require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "up returns ok without querying the database" do
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_name, _start, _finish, _id, payload|
      queries << payload[:sql] unless payload[:name].in?(["SCHEMA", "TRANSACTION"])
    end

    get "/up"

    assert_response :success
    assert_empty response.body
    assert_empty queries
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
  end
end
