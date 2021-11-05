class Order < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_presence_of :product_id, :cart_id, :quantity
  validates_uniqueness_of :product_id, scope: :cart_id
end
