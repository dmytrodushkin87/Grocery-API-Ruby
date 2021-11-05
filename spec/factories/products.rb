FactoryBot.define do
  factory :product do
    association :sub_category
    name { "Apple" }
    quantity { 10 }
    price { 20 }
    unit { "1 kg"}
  end
end