# require_relative "expand"

class CategorySerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :name, :photo_url, :created_at, :deleted_at, :link
  attribute :sub_categories, if: :condition?

  # has_many :sub_categories
  def condition?
    object.expand && object.expand.split(',').include?("sub_categories")
  end

  def sub_categories
    object.sub_categories
  end

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/categories/#{object.id}"
      },
      {
        rel: :sub_categories,
        href: "#{Settings.base_url}/api/v1/categories/#{object.id}/sub_categories"
      }
    ]
  end
end
