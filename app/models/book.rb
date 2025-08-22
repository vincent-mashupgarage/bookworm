class Book < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :title, presence: true
  validates :author, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :isbn, uniqueness: true, allow_blank: true

  before_save :generate_slug

  private

  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end
