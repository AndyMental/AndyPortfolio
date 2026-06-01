ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help" unless ENV["SKIP_DB_CHECK"]
require "minitest/autorun" if ENV["SKIP_DB_CHECK"]
require "action_dispatch/testing/integration" if ENV["SKIP_DB_CHECK"]

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end
