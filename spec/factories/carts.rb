FactoryBot.define do
  factory :cart do
    association :user
    mode_of_payment { "cash" }

    trait :confirmed do
      status { "confirmed" }
      confirmed_at { Time.now }
    end

    trait :pending do
      status { "pending" }
      pending_at { Time.now }
    end
  end
end