# Default seeds for AndyPortfolio.
#
# Ensures db/seeds.rb is idempotent and safe for production runs.
# Production has no required seed data for this application.

if Rails.env.production?
  puts "Production environment detected: Skipping development-only seeds."
  return
end

begin
  require 'ffaker'
rescue LoadError
  puts "FFaker not found. Skipping seeds."
  return
end

puts "Seeding development database..."

# Ensure idempotency by using a fixed seed for random data generation.
# This ensures that FFaker generates the same sequence of titles every time.
FFaker::Random.seed = 42
Kernel.srand(42)

# Create 50 sample blogs if they don't already exist.
# Using find_or_create_by! ensures that multiple runs of this script
# do not produce duplicate records.
50.times do |index|
  # Using FFaker with a fixed seed ensures these titles are stable across runs.
  t = FFaker::Book.title + ' ' + FFaker::CheesyLingo.title
  
  Blog.find_or_create_by!(title: t) do |blog|
    str = FFaker::HTMLIpsum.body
    s_str = str.split("/h1>")
    i = rand(10...100)
    
    # Safely handle the /h1> split.
    if s_str.size > 1
      # Insert an image after the first h1 tag.
      # Escaping quotes in alt text to avoid sanitize/parsing issues.
      alt_text = t.gsub('"', '&quot;')
      s_str.insert(1, "/h1><img src=\"https://picsum.photos/id/#{i}/600/300\" alt=\"#{alt_text}\">")
      blog.body = s_str.join("")
    else
      blog.body = str
    end
  end
end

puts "Seed complete! Total blogs: #{Blog.count}"
