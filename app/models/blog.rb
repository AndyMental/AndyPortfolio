class Blog < ApplicationRecord
  scope :search, ->(query) {
    where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  }
end
