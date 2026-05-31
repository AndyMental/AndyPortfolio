# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class SeedsTest < ActiveSupport::TestCase
  setup do
    # Clear blogs before testing seeds if necessary, 
    # though idempotent seeds should handle existing data.
    Blog.delete_all
  end

  test "seeds are idempotent" do
    # Initial seed
    puts "Running initial seed..."
    load Rails.root.join("db", "seeds.rb")
    initial_count = Blog.count
    assert_equal 50, initial_count, "Should create 50 blogs on first run"

    # Second seed
    puts "Running second seed..."
    load Rails.root.join("db", "seeds.rb")
    assert_equal initial_count, Blog.count, "Should not create duplicate blogs on second run"
  end

  test "seeds do not run in production" do
    # Mock Rails.env.production? to return true
    Rails.env.stub :production?, true do
      initial_count = Blog.count
      load Rails.root.join("db", "seeds.rb")
      assert_equal initial_count, Blog.count, "Should not create blogs in production"
    end
  end
end
