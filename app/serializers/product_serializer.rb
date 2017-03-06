class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :sold_out, :category, :price, :under_sale, :sale_price
end
