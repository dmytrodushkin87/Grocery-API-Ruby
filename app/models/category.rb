class Category < ApplicationRecord
  has_many :sub_categories, dependent: :delete_all

  validates_presence_of :name
end
