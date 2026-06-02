class AddSlugToBlogs < ActiveRecord::Migration[7.0]
  class MigrationBlog < ActiveRecord::Base
    self.table_name = "blogs"
  end

  RESERVED_SLUGS = %w[new].freeze

  def up
    add_column :blogs, :slug, :string

    MigrationBlog.reset_column_information
    used_slugs = []

    MigrationBlog.order(:id).find_each do |blog|
      base_slug = blog.title.to_s.parameterize.presence || "post"
      candidate = base_slug
      suffix = 2

      while used_slugs.include?(candidate) || RESERVED_SLUGS.include?(candidate)
        candidate = "#{base_slug}-#{suffix}"
        suffix += 1
      end

      blog.update_columns(slug: candidate)
      used_slugs << candidate
    end

    change_column_null :blogs, :slug, false
    add_index :blogs, :slug, unique: true
  end

  def down
    remove_index :blogs, :slug
    remove_column :blogs, :slug
  end
end
