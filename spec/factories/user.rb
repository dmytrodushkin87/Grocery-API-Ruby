FactoryBot.define do
  factory :user do
    first_name { Faker::Name.name }
    sequence(:mobile_number) {|n| "+91#{6315551212+n}"}
    sequence(:email) {|n| "patient_jdoe#{n}@mail.com"}
    password 'foobar'
  end
end