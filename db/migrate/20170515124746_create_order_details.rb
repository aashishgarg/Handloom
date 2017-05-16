class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.integer :header_id
      t.integer :item_variant_id
      t.integer :quantity

      t.timestamps
    end
  end
end
