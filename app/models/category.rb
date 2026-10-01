# Category model - represents a philosophical category (e.g. Ethics, Logic)
class Category < ApplicationRecord
  # A category can apply to many quotes via the join table
  has_many :quote_categories, dependent: :destroy
  has_many :quotes, through: :quote_categories

  validates :catname, presence: true, uniqueness: { case_sensitive: false }
end
