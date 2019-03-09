class Category < ApplicationRecord
  has_many :products

  scope :active, -> { where(active: true) }
end
