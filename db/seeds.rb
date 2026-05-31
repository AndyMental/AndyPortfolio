# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.production?
  puts "Seed data creation is disabled in production."
  return
end

begin
  require "ffaker"
rescue LoadError
  puts "ffaker gem not found, skipping seeds."
  return
end

puts "Seeding 50 blogs..."

# Set deterministic seeds for idempotency across runs
FFaker::Random.seed = 42
Kernel.srand 42

50.times do |i|
  # Deterministic title and body
  title = FFaker::Lorem.sentence
  body = FFaker::HTMLIpsum.fancy_string

  # Ensure the title is unique enough for find_or_create_by!
  # If FFaker produces a duplicate title within the 50 iterations, 
  # find_or_create_by! will just find the existing one.
  
  Blog.find_or_create_by!(title: title) do |blog|
    blog.body = body
  end
end

puts "Seed complete. Total blogs: #{Blog.count}"
