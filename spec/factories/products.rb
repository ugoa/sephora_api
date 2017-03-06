FactoryGirl.define do
  factory :product do
    name { Faker::Lorem.word }
    sold_out { Faker::Bollean.bollean }
    price { Faker::Number.between(1, 10_000) }
    under_sale { Faker::Bollean.bollean }
    sale_price { Faker::Number.between(1, 10_000) }
  end
end
