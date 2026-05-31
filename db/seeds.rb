# Default seeds intentionally do not create or delete blog content.
#
# Production has no required seed data for this application. Running
# `bin/rails db:seed` should remain safe in every environment.
puts "No default seed data required."

if ENV["BLOG_ADMIN_TOKEN"].to_s.empty?
  puts "NOTE: BLOG_ADMIN_TOKEN is not set. Admin features will return 404 until configured."
end
