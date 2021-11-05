FactoryBot.define do
  factory :offer do
    title { "Introductory offer" }
    description { "Applies to first time users"}
    value { 500 }
    max_value { 100 }
    kind {:cash }
    code { "CODE100"}
    starts_at { Chronic.parse('tomorrow at 8am') }
    finishes_at { Chronic.parse('1 week from tomorrow at 8am') }
    active true
  end
end