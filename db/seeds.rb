# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'ffaker'

Blog.destroy_all

50.times do |index|
    t = FFaker::Book.title + ' ' + FFaker::CheesyLingo.title
    str = FFaker::HTMLIpsum.body
    s_str = str.split("/h1>")
    i = rand(10...100)
    s_str.insert(1,'/h1><img src="https://picsum.photos/id/' + i.to_s + '/600/300" alt="' + t + '">')
    p = s_str.join("")
    Blog.create!(title: t, body: p)
end

p "Created #{Blog.count} blogs"