# require_relative "expand"

class OfferSerializer < ActiveModel::Serializer
  # include Expandable
  attributes :id, :description, :title, :value, :max_value, :kind, :code, :active,
    :starts_at, :finishes_at, :created_at, :deleted_at, :link
  attributes :offer_active

  def link
    [
      {
        rel: :self,
        href: "#{Settings.base_url}/api/v1/offers/#{object.id}"
      }
    ]
  end
end
