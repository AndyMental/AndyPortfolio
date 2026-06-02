class Blog < ApplicationRecord
  scope :search, ->(query) {
    query.to_s.split(/\s+/).reject(&:blank?).reduce(all) do |results, term|
      safe_term = sanitize_sql_like(term)
      matches_term = arel_table[:title].matches("%#{safe_term}%").or(arel_table[:body].matches("%#{safe_term}%"))

      results.where(matches_term)
    end
  }
end
