# User model - represents both standard users and admin users of MyQuote
class User < ApplicationRecord
  # Uses bcrypt via password_digest to hash and salt passwords securely
  has_secure_password

  # A user can have many quotes; destroy quotes if user is deleted
  has_many :quotes, dependent: :destroy

  # Validations
  validates :fname, presence: true
  validates :lname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, presence: true, inclusion: { in: %w[Active Suspended Banned] }

  # Normalise email before saving
  before_save { self.email = email.downcase }

  # Helper: is this user active (allowed to log in)?
  def active?
    status == "Active"
  end

  # Helper: full name convenience method
  def full_name
    "#{fname} #{lname}"
  end
end
