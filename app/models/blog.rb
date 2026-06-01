class Blog < ApplicationRecord
  scope :search, ->(query) {
    safe_query = sanitize_sql_like(query)
    where(arel_table[:title].matches("%#{safe_query}%").or(arel_table[:body].matches("%#{safe_query}%")))
  }

  scope :tagged_with, ->(tag) {
    where("tags ~* ?", "(^|,)\\s*#{Regexp.escape(tag)}\\s*($|,)")
  }

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:empty?)
  end
end
