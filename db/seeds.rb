# Default seeds intentionally do not create or delete blog content.
#
# Production has no required seed data for this application. Running
# `bin/rails db:seed` should remain safe in every environment.

if ENV["BLOG_ADMIN_TOKEN"].blank?
  puts "[WARNING] BLOG_ADMIN_TOKEN is not set. Admin features will be disabled."
end

puts "No default seed data required."
