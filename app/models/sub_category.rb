class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :products, dependent: :delete_all

  validates_presence_of :name
end
