namespace :dev do
  desc "Create deterministic demo blog posts for development and test"
  task seed_blogs: :environment do
    abort "dev:seed_blogs is only available in development and test." unless Rails.env.development? || Rails.env.test?

    created = 0

    50.times do |index|
      number = index + 1
      blog = Blog.find_or_initialize_by(title: "Demo Blog Post #{number}")
      next unless blog.new_record?

      blog.body = <<~HTML.squish
        <p><strong>Demo post #{number}</strong> introduces a portfolio update with practical project notes.</p>
        <p>Use this content while developing the blog index, detail, and admin flows.</p>
      HTML
      blog.save!
      created += 1
    end

    puts "Created #{created} demo blogs. Total blogs: #{Blog.count}."
  end
end
