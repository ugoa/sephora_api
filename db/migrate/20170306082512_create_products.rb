class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name, index: true
      t.boolean :sold_out
      t.string :category, index: true
      t.integer :price
      t.boolean :under_sale
      t.integer :sale_price

      t.timestamps
    end
  end
end
