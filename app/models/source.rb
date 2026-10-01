# Source model - represents the philosopher/person to whom a quote is attributed
class Source < ApplicationRecord
  # When a source is deleted, associated quotes have source_id set to nil
  # (quotes still belong to their user owner)
  has_many :quotes, dependent: :nullify

  # Only first name is required - many quotes attributed to "Anonymous"
  validates :fname, presence: true

  # Helper: display full name of source (handles anonymous/partial info)
  def full_name
    lname.present? ? "#{fname} #{lname}" : fname
  end

  # Helper: display life years e.g. "(470 BCE – 399 BCE)"
  def life_years
    return "" unless byear.present? || dyear.present?
    parts = [byear.presence, dyear.presence || "present"].compact
    "(#{parts.join(" – ")})"
  end
end
