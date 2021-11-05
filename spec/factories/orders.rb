FactoryBot.define do
  factory :order do
    association :cart
    association :product
    quantity { 2 }
  end
end