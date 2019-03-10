class Product < ApplicationRecord
  belongs_to :category

  scope :active, -> { joins(:category).where(active: true).merge(Category.active) }

  def self.search(query)
    query = "%#{query}%"
    where(arel_table[:name].matches(query).or(arel_table[:sku].matches(query)))
  end

  def self.above_price(price)
    where(arel_table[:price].gteq(price))
  end

  def self.below_price(price)
    where(arel_table[:price].lteq(price))
  end
end
