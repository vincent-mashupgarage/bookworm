class User < ApplicationRecord
    has_secure_password

    has_many :orders, dependent: :destroy
    has_many :carts, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true
    validates :role, inclusion: { in: %w[admin customer] }
end
