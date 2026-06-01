class Blog < ApplicationRecord
  scope :search, ->(query) {
    safe_query = sanitize_sql_like(query)
    where(arel_table[:title].matches("%#{safe_query}%").or(arel_table[:body].matches("%#{safe_query}%")))
  }

  def estimated_reading_time
    return 0 if body.nil?

    words_per_minute = 200
    words = body.split.size
    minutes = (words / words_per_minute.to_f).ceil
    minutes
  end
end
