FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.name }
    association :restaurant
  end
end
