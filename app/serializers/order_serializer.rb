class OrderSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :created_at, :link
  attribute :products, if: :product?

  # has_many :sub_categories
  def product?
    object.expand && object.expand.split(',').include?("product")
  end

  def products
    object.product
  end

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/orders/#{object.id}"
      },
      {
        rel: :product,
        href: "#{Settings.base_url}/api/v1/products/#{object.product_id}"
      },
      {
        rel: :cart,
        href: "#{Settings.base_url}/api/v1/carts/#{object.cart_id}"
      }
    ]
  end
end
