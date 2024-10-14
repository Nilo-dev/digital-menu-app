FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 1.0..100.0) }
    menu
  end
end
