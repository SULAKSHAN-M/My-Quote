# Quote model - represents a philosophical quote collected by a user
class Quote < ApplicationRecord
  # A quote belongs to one user (its owner) and one source (the philosopher)
  belongs_to :user
  belongs_to :source

  # Many-to-many relationship with categories via the quote_categories join table
  has_many :quote_categories, dependent: :destroy
  has_many :categories, through: :quote_categories

  # Validations
  validates :qtext, presence: true
  validates :ispublic, inclusion: { in: [true, false] }

  # Scope: only public quotes (for homepage and search)
  scope :public_quotes, -> { where(ispublic: true) }

  # Scope: most recently added public quotes
  scope :recent_public, -> { public_quotes.order(created_at: :desc) }
end
