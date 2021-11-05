class Product < ApplicationRecord

  belongs_to :sub_category

  DISCOUNT_KINDS = [:cash, :discount]

  validates_presence_of :name
  validates :discount_kind, inclusion: { in: DISCOUNT_KINDS}, allow_nil: true
end
