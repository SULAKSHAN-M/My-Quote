# QuoteCategory model - join/bridging table linking quotes to categories
# Supports the many-to-many relationship between Quote and Category
class QuoteCategory < ApplicationRecord
  belongs_to :quote
  belongs_to :category
end
