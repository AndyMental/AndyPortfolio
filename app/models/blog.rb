class Blog < ApplicationRecord
  RESERVED_SLUGS = %w[new].freeze

  before_validation :set_slug, on: :create

  validates :slug, presence: true, uniqueness: true

  scope :search, ->(query) {
    safe_query = sanitize_sql_like(query)
    where(arel_table[:title].matches("%#{safe_query}%").or(arel_table[:body].matches("%#{safe_query}%")))
  }

  def to_param
    slug
  end

  private
    def set_slug
      return if slug.present?

      base_slug = title.to_s.parameterize.presence || "post"
      candidate = base_slug
      suffix = 2

      while slug_taken?(candidate)
        candidate = "#{base_slug}-#{suffix}"
        suffix += 1
      end

      self.slug = candidate
    end

    def slug_taken?(candidate)
      RESERVED_SLUGS.include?(candidate) || self.class.exists?(slug: candidate)
    end
end
