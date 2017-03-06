class Product < ApplicationRecord
  validates :name, presence: true

  validates :category, inclusion: { in: %w(markup tools brushes) }
end
