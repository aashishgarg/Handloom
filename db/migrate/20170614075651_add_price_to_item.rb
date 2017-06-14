class AddPriceToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :price, :decimal

    Item.update_all(price: 0)
  end
end
