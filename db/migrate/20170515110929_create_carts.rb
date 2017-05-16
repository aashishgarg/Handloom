class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :item_variant_id
      t.integer :quantity

      t.timestamps
    end
  end
end
