require "test_helper"

# Loads config/environments/production.rb against the current application and
# asserts the Render TLS hardening flags are active. Snapshot/restore the few
# attributes the production file mutates so this test does not leak production
# settings into sibling tests within the same Minitest worker.
class ProductionConfigTest < ActiveSupport::TestCase
  test "production environment enables force_ssl for Render TLS" do
    config = Rails.application.config
    snapshot = {
      cache_classes: config.cache_classes,
      eager_load: config.eager_load,
      consider_all_requests_local: config.consider_all_requests_local,
      force_ssl: config.force_ssl,
      log_level: config.log_level,
    }

    load Rails.root.join("config/environments/production.rb").to_s

    assert_equal true, Rails.application.config.force_ssl,
      "config/environments/production.rb must set config.force_ssl = true"
  ensure
    if snapshot
      snapshot.each { |key, value| config.public_send("#{key}=", value) }
    end
  end
end
