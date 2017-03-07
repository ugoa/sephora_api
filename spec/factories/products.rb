FactoryGirl.define do
  factory :product do
    number = Faker::Number.between(1, 10_000)
    name { Faker::Commerce.product_name }
    sold_out { [true, false].sample }
    category { %w(markup tools brushes).sample }
    price { number }
    under_sale { [true, false].sample }
    sale_price { Faker::Number.between(1, number) }
  end
end
