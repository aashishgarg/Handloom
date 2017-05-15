class CreateItemVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :item_variants do |t|
      t.integer :item_id
      t.decimal :price
      t.decimal :special_price

      # ---------- Properties -------------- #
      t.integer :color_id
      t.integer :brand_id
      t.integer :size_id
      t.integer :material_id

      t.timestamps
    end
  end
end
