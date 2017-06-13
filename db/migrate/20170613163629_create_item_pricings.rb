class CreateItemPricings < ActiveRecord::Migration[5.0]
  def change
    create_table :item_pricings do |t|
      t.integer :item_id, null: false
      t.integer :user_id, null: false
      t.decimal :price, null: false

      t.timestamps
    end
  end
end
