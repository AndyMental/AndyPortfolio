require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "should get up" do
    get "/up"
    assert_response :success
    assert_equal "OK", response.body
  end

  test "should not hit database" do
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_name, _start, _finish, _id, payload|
      queries << payload[:sql] unless ["SCHEMA", "TRANSACTION"].include?(payload[:name])
    end

    begin
      get "/up"
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end

    assert_empty queries, "Database should not be queried, but saw: #{queries.join(', ')}"
  end
end
