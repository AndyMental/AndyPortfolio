class Blog < ApplicationRecord
  scope :search, ->(query) {
    where(arel_table[:title].matches("%#{query}%").or(arel_table[:body].matches("%#{query}%")))
  }
end
