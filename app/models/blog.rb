class Blog < ApplicationRecord
  scope :search, ->(query) {
    safe_query = sanitize_sql_like(query)
    where(arel_table[:title].matches("%#{safe_query}%").or(arel_table[:body].matches("%#{safe_query}%")))
  }
end
