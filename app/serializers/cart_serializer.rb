# require_relative "expand"

class CartSerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :mode_of_payment, :status, :addres_line_1, :addres_line_2, :city, :postal_code, :state,
    :delivery_place, :mobile_number, :unconfirmed_at, :pending_at, :approved_at, :confirmed_at,
    :cancelled_at, :delivered_at, :delivery_person_name, :delivery_person_mobile_number,
    :created_at, :updated_at, :link

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/carts/#{object.id}"
      },
      {
        rel: :orders,
        href: "#{Settings.base_url}/api/v1/carts/#{object.id}/orders"
      }
    ]
  end
end
