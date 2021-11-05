# require_relative "expand"

class UserSerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :first_name, :last_name, :email, :address_line_1, :address_line_2, :latitude,
    :longitude, :city, :province, :postal_code, :country, :photo_url, :mobile_number,
    :date_of_birth, :new_email, :new_mobile_number, :whatsapp_mobile_number,
    :created_at, :updated_at, :link

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/users/#{object.id}"
      },
      {
        rel: :cart,
        href: "#{Settings.base_url}/api/v1/users/#{object.id}/carts"
      }
    ]
  end
end
