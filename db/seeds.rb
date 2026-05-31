# Default seeds intentionally do not create or delete blog content.
#
# Production has no required seed data for this application. Running
# `bin/rails db:seed` should remain safe in every environment.
if ENV["BLOG_ADMIN_TOKEN"].to_s.strip.empty?
  warn "WARNING: BLOG_ADMIN_TOKEN is not set. Admin blog features will be disabled."
  warn "Set BLOG_ADMIN_TOKEN in your environment to enable administrative access."
end

puts "No default seed data required."
