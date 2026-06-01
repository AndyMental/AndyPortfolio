# Default seeds intentionally do not create or delete blog content.
#
# Production has no required seed data for this application. Running
# `bin/rails db:seed` should remain safe in every environment.
if ENV["BLOG_ADMIN_TOKEN"].to_s.empty?
  $stderr.puts "WARNING: BLOG_ADMIN_TOKEN is missing. Admin features (creating/editing blogs) will be unavailable."
  $stderr.puts "Please set the BLOG_ADMIN_TOKEN environment variable in your environment."
end

puts "No default seed data required."
