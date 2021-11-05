# require_relative "expand"

class SubCategorySerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :name, :created_at, :deleted_at, :link
  attribute :category, if: :category?

  # has_many :sub_categories
  def category?
    object.expand && object.expand.split(',').include?("category")
  end

  def category
    object.category
  end

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/categories/#{object.category_id}/sub_categories/#{object.id}"
      },
      {
        rel: :category,
        href: "#{Settings.base_url}/api/v1/categories/#{object.id}"
      }
    ]
  end
end
