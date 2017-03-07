# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.destroy_all
200.times do
  Product.create do |p|
    number = Faker::Number.between(1, 10_000)
    p.name = Faker::Commerce.product_name
    p.sold_out = [true, false].sample
    p.category = %w(markup tools brushes).sample
    p.price = number
    p.under_sale = [true, false].sample
    p.sale_price = Faker::Number.between(1, number)
  end
end
