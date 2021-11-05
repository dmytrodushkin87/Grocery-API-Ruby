class Offer < ApplicationRecord
  validates_presence_of :code

  def offer_active
    active && starts_at < Time.now && finishes_at >= Time.now
  end
end
