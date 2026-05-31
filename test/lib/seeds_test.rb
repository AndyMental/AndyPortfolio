require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  setup do
    Blog.destroy_all
  end

  test "seeds are idempotent" do
    # Load seeds for the first time
    silence_stream($stdout) do
      load Rails.root.join("db", "seeds.rb")
    end
    initial_count = Blog.count
    assert_equal 50, initial_count, "Should create 50 blogs on first run"

    # Load seeds for the second time
    silence_stream($stdout) do
      load Rails.root.join("db", "seeds.rb")
    end
    
    assert_equal initial_count, Blog.count, "Blog count should not change on second run"
    
    # Verify titles are what we expect from the fixed seed
    # (Just a sanity check that find_or_create_by! matched on title)
    titles = Blog.pluck(:title)
    assert_equal titles.uniq.count, titles.count, "All seeded titles should be unique"
  end

  private

  # Helper to suppress puts from seeds.rb during tests
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(File::NULL)
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
    old_stream.close
  end
end
