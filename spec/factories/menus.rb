FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.name }
  end
end
