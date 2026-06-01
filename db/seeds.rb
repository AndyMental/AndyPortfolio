# Default seeds intentionally do not create or delete blog content.
#
# Production has no required seed data for this application. Running
# `bin/rails db:seed` should remain safe in every environment.
if ENV["BLOG_ADMIN_TOKEN"].to_s.empty?
  warn "WARNING: BLOG_ADMIN_TOKEN is missing. Admin access to blogs will be disabled."
  warn "Action: Set the BLOG_ADMIN_TOKEN environment variable to enable admin features."
end
puts "No default seed data required."
