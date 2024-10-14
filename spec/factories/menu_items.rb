FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
  end

  factory :menu_item_menu do
    association :menu
    association :menu_item
    description { "Delicious" }
    price { Faker::Commerce.price(range: 1.0..100.0) }
  end
end
