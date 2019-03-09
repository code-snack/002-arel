class Product < ApplicationRecord
  belongs_to :category

  scope :active, -> { joins(:category).where(active: true).where('categories.active = ?', true) }
  scope :search, ->(query) { where('name ilike :query OR sku ilike :query', query: "%#{query}%") }

  def self.above_price(price)
    where('price >= ?', price)
  end

  def self.below_price(price)
    where('price <= ?', price)
  end
end
