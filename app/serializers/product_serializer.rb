# require_relative "expand"

class ProductSerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :name, :quantity, :price, :discount, :availability, :photo_url, :unit,
    :discount_kind, :tax_rate, :description, :created_at, :deleted_at, :link
  attribute :sub_category, if: :condition?

  # has_many :sub_categories
  def condition?
    object.expand && object.expand.split(',').include?("sub_category")
  end

  def sub_categories
    object.sub_category
  end

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/products/#{object.id}"
      },
      {
        rel: :sub_category,
        href: "#{Settings.base_url}/api/v1/sub_categories/#{object.sub_category_id}"
      }
    ]
  end
end
